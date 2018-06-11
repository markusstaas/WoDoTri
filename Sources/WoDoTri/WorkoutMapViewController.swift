import UIKit
import MapKit


final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    

    override func viewDidLoad() {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(userLocation, 500, 500)
            mapView.setRegion(region, animated: true)
        }
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = false
        mapView.userTrackingMode = .followWithHeading
    }
}
