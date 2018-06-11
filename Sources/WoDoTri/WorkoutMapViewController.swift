import UIKit
import MapKit

protocol WorkoutMapViewControllerDataSource: AnyObject {
    func currentLocation(for workoutMapViewController: WorkoutMapViewController) -> CLLocationCoordinate2D
}

final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!

    weak var dataSource: WorkoutMapViewControllerDataSource!

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
