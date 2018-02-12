//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import CoreLocation
import CoreData
import MapKit
import Alamofire

final class ActivityFinishViewController: UIControls, MKMapViewDelegate {

    var activityDuration: String?
    var finalTimestamp: Date?

    private let defaults = UserDefaults.standard
    private var activity: Activity!
    private let workoutData = Workout.shared
    private var subContext = CoreDataStack.context
    private let stopwatch = StopWatch()
    private var coords = [CLLocationCoordinate2D]()

    @IBOutlet private weak var activityTypeLabel: UILabel!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var avgPaceLabel: UILabel!
    @IBOutlet private weak var completedDistanceLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {

        super.viewDidLoad()
        activityTypeLabel.text = workoutData.activityType.description
        elapsedTimeLabel.text = "Duration: \(workoutData.durationString)"
        completedDistanceLabel.text = "Distance: \(workoutData.distanceString())"
        avgPaceLabel.text = "Average speed: \(workoutData.avgPaceString())"
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(managedObjectContextDidSave),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: subContext)

        for location in workoutData.locationList {
            let coordItem: CLLocationCoordinate2D = location.coordinate
            coords.append(coordItem)
        }
         loadMap()
    }

    @IBAction private func continueButtonPressed() {
       self.dismiss(animated: true, completion: nil)
        workoutData.activityState = .restarted
    }

    @IBAction private func finishButtonPressed(_ sender: Any) {
        saveActivity()
        workoutData.activityState = .notStarted
    }

    @IBAction private func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
        workoutData.activityState = .notStarted
        self.dismiss(animated: true, completion: nil)
    }

    //////Core Data
    private func saveActivity() {
        let newActivity = Activity(context: CoreDataStack.context)
        newActivity.distance = workoutData.distance.value
        newActivity.duration = workoutData.duration
        newActivity.durationString = workoutData.durationString
        newActivity.type = workoutData.activityType.description
        newActivity.timestamp = Date()

        for location in workoutData.locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newActivity.addToLocations(locationObject)
        }
        CoreDataStack.saveContext()
        activity = newActivity
        createStravaFile()
    }

    private func createStravaFile() {
        let timeStampFormatter = DateFormatter()
        timeStampFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        var gpxText: String = String("""
            <?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\"
            creator=\"WoDoTri\" xmlns=\"http://www.topografix.com/GPX/1/1\"
            xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
            xmlns:gte=\"http://www.gpstrackeditor.com/xmlschemas/General/1\"
            xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">
            <trk><activity_type>\"Ride\"</activity_type><trkseg>
            """)

        for locations in workoutData.locationList {
            //let formattedTimeStamp = timeStampFormatter.date(from: String(describing: locations.timestamp))
            let formattedTimeStamp = timeStampFormatter.string(from: locations.timestamp)
            let newLine: String = String("""
                <trkpt lat=\"\(String(format: "%.6f", locations.coordinate.latitude))\
                " lon=\"\(String(format: "%.6f", locations.coordinate.longitude))\">
                <time>\(formattedTimeStamp)</time></trkpt>
                """)
            gpxText.append(contentsOf: newLine)
        }

        gpxText.append("</trkseg></trk></gpx>")

        do {
            let stravaToken = defaults.value(forKey: "StravaToken")
            let uploadUrl = "https://www.strava.com/api/v3/uploads" /* your API url */
            let headers: HTTPHeaders = [ "Authorization": "Bearer \(stravaToken!)"]
            let parameters: Parameters = [
              "activity_type": workoutData.activityType.description,
                "file": "@file.gpx",
                "data_type": "gpx"
            ]

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if let gpxSubmitData = gpxText.data(using: .utf8) {
                    multipartFormData.append(
                        gpxSubmitData,
                        withName: "file",
                        fileName: "file.gpx",
                        mimeType: "application/gpx"
                    )
                }
            }, usingThreshold: UInt64.init(),
               to: uploadUrl,
               method: .post,
               headers: headers,
               encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.description)
                        if let err = response.error {
                            print(err)
                            return
                        }
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    print(error)
                }
            }
            )
        }
    }

    private func mapRegion() -> MKCoordinateRegion? {

        let latitudes = coords.map { location -> Double in
            let location = location
            return location.latitude
        }

        let longitudes = coords.map { location -> Double in
            let location = location
            return location.longitude
        }

        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3)

        return MKCoordinateRegion(center: center, span: span)
    }

    private func polyLine() -> MKPolyline {
        return MKPolyline(coordinates: coords, count: coords.count)
    }

    private func loadMap() {
        guard
            coords.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Sorry, this activity has no locations saved",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }

        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .purple
        renderer.lineWidth = 4
        return renderer
    }

}
