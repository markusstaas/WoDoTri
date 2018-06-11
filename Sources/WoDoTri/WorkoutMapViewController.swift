import UIKit
import MapKit

final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var centerOnMap: UIButton!

    @IBAction func centerOnMapTapped(_ sender: UIButton) {
        mapView.userTrackingMode = .followWithHeading
        centerOnMap.isHidden = true
    }
    override func viewDidLoad() {

        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self

        centerOnMap.isHidden = true
        mapView.userTrackingMode = .followWithHeading
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = false
        mapView.addGestureRecognizer(mapDragRecognizer)

    }
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            centerOnMap.isHidden = false
        }
    }
}

// MARK: - Manage UIGestureRecognizerDelegate

extension WorkoutMapViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
