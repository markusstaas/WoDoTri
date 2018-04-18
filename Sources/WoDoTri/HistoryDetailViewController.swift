////  Copyright © 2017 Markus Staas. All rights reserved.
//
//import UIKit
//import MapKit
//
//final class HistoryDetailViewController: UIViewController, MKMapViewDelegate {
//
//    @IBOutlet private weak var activityTypeLabel: UILabel!
//    @IBOutlet private weak var elapsedTimeLabel: UILabel!
//    @IBOutlet private weak var avgPaceLabel: UILabel!
//    @IBOutlet private weak var completedDistanceLabel: UILabel!
//    @IBOutlet private weak var dateLabel: UILabel!
//    @IBOutlet private weak var mapView: MKMapView!
//
//    var workout: Workout!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureView()
//    }
//
//    private func configureView() {
//
//        let distance = Measurement(value: activity.distance, unit: UnitLength.meters)
//        let seconds = Int(activity.duration)
//        let formattedDistance = Workout.makeDistanceText(for: distance)
//        let formattedDate = FormatDisplay.date(activity.timestamp)
//        let formattedTime = activity.durationString
//        let formattedPace = FormatDisplay.pace(
//            distance: distance,
//            seconds: seconds,
//            outputUnit: UnitSpeed.minutesPerMile
//        )
//
//        activityTypeLabel.text = workout.type
//        completedDistanceLabel.text = "Distance:  \(workout.distanceText)"
//        dateLabel.text = formattedDate
//        elapsedTimeLabel.text = "Time:  \(formattedTime!)"
//        avgPaceLabel.text = "Pace:  \(formattedPace)"
//        //loadMap()
//    }
//
////    private func mapRegion() -> MKCoordinateRegion? {
////        guard activity.locations.count > 0 else {
////            print("No locations found")
////            return nil
////        }
////        let latitudes = activity.locations.map { $0.latitude }
////        let longitudes = activity.locations.map { $0.longitude }
////        let maxLat = latitudes.max()!
////        let minLat = latitudes.min()!
////        let maxLong = longitudes.max()!
////        let minLong = longitudes.min()!
////        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
////        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3)
////        return MKCoordinateRegion(center: center, span: span)
////    }
////
////    private func loadMap() {
////        guard activity.locations.count > 0,
////            let region = mapRegion()
////            else {
////                let alert = UIAlertController(
////                    title: "Error",
////                    message: "Sorry, this run has no locations saved",
////                    preferredStyle: .alert
////                )
////                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
////                present(alert, animated: true)
////                return
////        }
////        mapView.setRegion(region, animated: true)
////        mapView.add(polyLine())
////    }
////
////    private func polyLine() -> MKPolyline {
////        let sortedLocations = activity.locations.sorted { $0.timestamp < $1.timestamp }
////        let coords: [CLLocationCoordinate2D] = sortedLocations.map { location in
////            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
////        }
////        return MKPolyline(coordinates: coords, count: coords.count)
////    }
////
////    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////        guard let polyline = overlay as? MKPolyline else {
////            return MKOverlayRenderer(overlay: overlay)
////        }
////        let renderer = MKPolylineRenderer(polyline: polyline)
////        renderer.strokeColor = .black
////        renderer.lineWidth = 3
////        return renderer
////    }
//
//}
