import UIKit
import MapKit

protocol WorkoutMapViewControllerDataSource: AnyObject {

    func locationHistory(for workoutMapViewController: WorkoutMapViewController) -> Set<WorkoutLocation>
    func currenLocation(for workoutMapViewController: WorkoutMapViewController) -> WorkoutLocation
}

final class WorkoutMapViewController: UIViewController {

    weak var dataSource: WorkoutMapViewControllerDataSource!
    private var locationManager = CLLocationManager()
    private var coords = [CLLocationCoordinate2D]()

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var centerMapOnUserLocationButton: UIButton!

    @IBAction func initiateCenterMapOnUserLocation() {
        centerMapOnUserLocation()
    }

    override func viewDidLoad() {
        loadMap()
    }

    private func loadMap() {
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = true
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(showCenterMapOnUserLocationButton(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        centerMapOnUserLocationButton.isHidden = true
        self.mapView.addGestureRecognizer(mapDragRecognizer)
        centerMapOnUserLocation()
    }

    private func centerMapOnUserLocation() {
        mapView.userTrackingMode = .followWithHeading
        centerMapOnUserLocationButton.isHidden = true
        let span = MKCoordinateSpan.init(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let location = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(coordinateRegion, animated: false)

    }

    @objc private func showCenterMapOnUserLocationButton(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state ==  UIGestureRecognizer.State.began {
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
