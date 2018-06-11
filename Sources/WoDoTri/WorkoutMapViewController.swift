import UIKit
import MapKit

final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!

    @IBAction func centerOnMapTapped(_ sender: Any) {
        mapView.userTrackingMode = .followWithHeading
    }
    override func viewDidLoad() {
        mapView.userTrackingMode = .followWithHeading
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = false

    }
}
