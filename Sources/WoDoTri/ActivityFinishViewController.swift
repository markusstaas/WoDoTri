////  Copyright © 2017 Markus Staas. All rights reserved.
//
//import UIKit
//import CoreLocation
//import CoreData
//import MapKit
//import Alamofire
//
//final class ActivityFinishViewController: UIViewController, MKMapViewDelegate {
//
//    var activityDuration: String?
//    var finalTimestamp: Date?
//
//    private let defaults = UserDefaults.standard
//
//    @IBAction private func continueButtonPressed() {
//       self.dismiss(animated: true, completion: nil)
//        workout.activityState = .restarted
//    }
//
//    @IBAction private func finishButtonPressed(_ sender: Any) {
//        saveActivity()
//        workout.activityState = .notStarted
//    }
//
//
//    //////Core Data
//    private func saveActivity() {
//        let newActivity = Activity(context: CoreDataStack.context)
//        newActivity.distance = workout.distance.value
//        newActivity.duration = workout.duration
//        newActivity.durationString = workout.durationString
//        newActivity.type = workout.activityType.description
//        newActivity.timestamp = Date()
//
//        for location in workout.locationList {
//            let locationObject = Location(context: CoreDataStack.context)
//            locationObject.timestamp = location.timestamp
//            locationObject.latitude = location.coordinate.latitude
//            locationObject.longitude = location.coordinate.longitude
//            newActivity.addToLocations(locationObject)
//        }
//
//        activity = newActivity
//        createStravaFile()
//        CoreDataStack.saveContext()
//        presentWorkoutSavedAlert()
//    }
//
//    private func presentWorkoutSavedAlert() {
//        let alertTitle = NSLocalizedString("Workout Saved", comment: "")
//        let alertMessage = NSLocalizedString("Your workout has been saved.", comment: "")
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
//        let actionTitle = NSLocalizedString("OK", comment: "")
//        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
//            self?.performSegue(withIdentifier: "Dismiss", sender: self)
//        }
//        alert.addAction(action)
//        present(alert, animated: true)
//    }
//
//    private func createStravaFile() {
//        let timeStampFormatter = DateFormatter()
//        timeStampFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
//        var gpxText: String = String("""
//            <?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\"
//            creator=\"WoDoTri\" xmlns=\"http://www.topografix.com/GPX/1/1\"
//            xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
//            xmlns:gte=\"http://www.gpstrackeditor.com/xmlschemas/General/1\"
//            xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">
//            <trk><activity_type>\"Ride\"</activity_type><trkseg>
//            """)
//
//        for locations in workout.locationList {
//            //let formattedTimeStamp = timeStampFormatter.date(from: String(describing: locations.timestamp))
//            let formattedTimeStamp = timeStampFormatter.string(from: locations.timestamp)
//            let newLine: String = String("""
//                <trkpt lat=\"\(String(format: "%.6f", locations.coordinate.latitude))\
//                " lon=\"\(String(format: "%.6f", locations.coordinate.longitude))\">
//                <time>\(formattedTimeStamp)</time></trkpt>
//                """)
//            gpxText.append(contentsOf: newLine)
//        }
//
//        gpxText.append("</trkseg></trk></gpx>")
//
//        do {
//            let stravaToken = defaults.value(forKey: "StravaToken")
//            let uploadUrl = "https://www.strava.com/api/v3/uploads" /* your API url */
//            let headers: HTTPHeaders = [ "Authorization": "Bearer \(stravaToken!)"]
//            let parameters: Parameters = [
//              "activity_type": workout.activityType.description,
//                "file": "@file.gpx",
//                "data_type": "gpx"
//            ]
//
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in parameters {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                }
//                if let gpxSubmitData = gpxText.data(using: .utf8) {
//                    multipartFormData.append(
//                        gpxSubmitData,
//                        withName: "file",
//                        fileName: "file.gpx",
//                        mimeType: "application/gpx"
//                    )
//                }
//            }, usingThreshold: UInt64.init(),
//               to: uploadUrl,
//               method: .post,
//               headers: headers,
//               encodingCompletion: { (result) in
//                switch result {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        print(response.description)
//                        if let err = response.error {
//                            print(err)
//                            return
//                        }
//                    }
//                case .failure(let error):
//                    print("Error in upload: \(error.localizedDescription)")
//                    print(error)
//                }
//            }
//            )
//        }
//    }
