import UIKit
import MapKit

final class WorkoutMapViewController: UIViewController {

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
