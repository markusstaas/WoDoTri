import UIKit
import MapKit

protocol WorkoutMapViewControllerDataSource: AnyObject {
    func currentLocation(for workoutMapViewController: WorkoutMapViewController) -> CLLocationCoordinate2D
}

final class WorkoutMapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!

    weak var dataSource: WorkoutMapViewControllerDataSource!

    func updateView() {
        let region = MKCoordinateRegionMakeWithDistance(dataSource.currentLocation(for: self), 500, 500)
        mapView.setRegion(region, animated: true)
    }
}
