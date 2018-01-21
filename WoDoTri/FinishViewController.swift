//
//  FinishViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/12/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit
import Alamofire

class FinishViewController: UIControls, MKMapViewDelegate{
    
    let defaults = UserDefaults.standard
    var activity: Activity!
    let workoutData = WorkoutData.shared
    var subContext = CoreDataStack.context
    let stopwatch = StopWatch()
    var activityDuration: String?
    var finalTimestamp: Date?
    var coords = [CLLocationCoordinate2D]()

    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var completedDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityTypeLabel.text = workoutData.activityType.description
        elapsedTimeLabel.text = "Duration: \(workoutData.durationString)"
        completedDistanceLabel.text = "Distance: \(workoutData.distanceString())"
        avgPaceLabel.text = "Average speed: \(workoutData.avgPaceString())"
       
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: subContext)
       
        for location in workoutData.locationList {
            let coordItem: CLLocationCoordinate2D = location.coordinate
            coords.append(coordItem)
        }
         loadMap()
    }
    @IBAction func continueButtonPressed() {
       
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        saveActivity()
        workoutData.activityState = .notStarted
    }
    @IBAction func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
        workoutData.activityState = .notStarted
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
    private func createStravaFile(){
        let fileName = "stravatempupload.GPX"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
      
        let timeStampFormatter = DateFormatter()
        timeStampFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
    
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        // Set the contents
        var gpxText : String = String("<?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\" creator=\"yourAppNameHere\" xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:gte=\"http://www.gpstrackeditor.com/xmlschemas/General/1\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">")
        gpxText.append("<trk><trkseg>")
        for locations in workoutData.locationList{
            //let formattedTimeStamp = timeStampFormatter.date(from: String(describing: locations.timestamp))
            let formattedTimeStamp = timeStampFormatter.string(from: locations.timestamp)
            let newLine : String = String("<trkpt lat=\"\(String(format:"%.6f", locations.coordinate.latitude))\" lon=\"\(String(format:"%.6f", locations.coordinate.longitude))\"><time>\(formattedTimeStamp)</time></trkpt>")
            gpxText.append(contentsOf: newLine)
        }
        gpxText.append("</trkseg></trk></gpx>")
        
        
        do {
            // Write contents to file
            try gpxText.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Could not create file \(error)")
        }
        
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            
            print(contentFromFile)
            
            let stravaToken = defaults.value(forKey: "StravaToken")
            print(stravaToken)
            let uploadUrl = "https://www.strava.com/api/v3/uploads" /* your API url */
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(stravaToken!)"
            ]
            let parameters: Parameters = [
                "activity_type" : workoutData.activityType,
                "file" : "@file.gpx",
                "data_type" : "gpx"
            ]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if let gpxSubmitData = gpxText.data(using: .utf8){
                    multipartFormData.append(gpxSubmitData, withName: "file", fileName: "file.gpx", mimeType: "application/gpx")
                }
                
            }, usingThreshold: UInt64.init(), to: uploadUrl, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        print(response.description)
                        if let err = response.error{
                            print(err)
                            return
                        }
                       // onCompletion?(nil)
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    print(error)
                }
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
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
                let alert = UIAlertController(title: "Error", message: "Sorry, this activity has no locations saved", preferredStyle: .alert)
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
