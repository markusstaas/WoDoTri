import UIKit
import MapKit

protocol WorkoutMapViewControllerDataSource: AnyObject {

    func locationHistory(for workoutMapViewController: WorkoutMapViewController) -> Set<WorkoutLocation>
    func currenLocation(for workoutMapViewController: WorkoutMapViewController) -> WorkoutLocation
}

final class WorkoutMapViewController: UIViewController {

    weak var dataSource: WorkoutMapViewControllerDataSource!

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var centerMapOnUserLocationButton: UIButton!

    @IBAction func centerMapOnUserLocation() {
        mapView.userTrackingMode = .followWithHeading
        centerMapOnUserLocationButton.isHidden = true
    }

    override func viewDidLoad() {
        centerMapOnUserLocation()
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = false
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(showCenterMapOnUserLocationButton(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        self.mapView.addGestureRecognizer(mapDragRecognizer)

    }

    @objc private func showCenterMapOnUserLocationButton(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state ==  UIGestureRecognizerState.began {
            centerMapOnUserLocationButton.isHidden = false
        }
    }
}

// MARK: - Managing UIGestureRecognizerDelegate

extension WorkoutMapViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension WorkoutMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

//extension WorkoutMapViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for newLocation in locations {
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
//            if let lastLocation = workout.locationList.last {
//                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
//                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
//                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
//                mapView.setRegion(region, animated: true)
//            }
//            workout.locationList.append(newLocation)
//        }
//    }
//}
