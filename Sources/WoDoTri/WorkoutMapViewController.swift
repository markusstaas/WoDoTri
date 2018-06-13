import UIKit
import MapKit

final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
<<<<<<< ours

    @IBAction func centerOnMapTapped(_ sender: Any) {
        mapView.userTrackingMode = .followWithHeading
    }
    override func viewDidLoad() {
=======
    @IBOutlet weak private var centerMapOnUserLocationButton: UIButton!

    @IBAction func centerMapOnUserLocation() {
        mapView.userTrackingMode = .followWithHeading
        centerMapOnUserLocationButton.isHidden = true
    }

    override func viewDidLoad() {
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.showCenterMapOnUserLocationButton(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        centerMapOnUserLocationButton.isHidden = true
>>>>>>> theirs
        mapView.userTrackingMode = .followWithHeading
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = false
<<<<<<< ours

    }
<<<<<<< ours
=======
    @objc private func didDragMap(gestureRecognizer: UIGestureRecognizer) {
=======
        mapView.addGestureRecognizer(mapDragRecognizer)
    }

    @objc private func showCenterMapOnUserLocationButton(gestureRecognizer: UIGestureRecognizer) {
>>>>>>> theirs
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            centerMapOnUserLocationButton.isHidden = false
        }
    }
}

// MARK: - Manage UIGestureRecognizerDelegate

extension WorkoutMapViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

>>>>>>> theirs
}
