//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit
import CoreData
import MapKit

protocol WorkoutFinishedViewControllerDataSource: AnyObject {

    func workoutType(for workoutFinishedViewController: WorkoutFinishedViewController) -> WorkoutType
    func workoutDistance(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutDuration(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutLocationHistory(for workoutFinishedViewController: WorkoutFinishedViewController) -> Set<WorkoutLocation>
}

class WorkoutFinishedViewController: UIViewController, MKMapViewDelegate {

    private var coords = [CLLocationCoordinate2D]()
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var dataSource: WorkoutFinishedViewControllerDataSource?
    @IBOutlet weak var mapView: MKMapView!


    @IBAction func saveWorkoutToLog(_ sender: Any) {
        appDelegate?.saveContext()
//        let alert = UIAlertController(
//            title: "Error",
//            message: "Sorry, this activity has no locations saved",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locations = Array(dataSource!.workoutLocationHistory(for: self))
        for location in locations.sorted(by: ({$0.timestamp < $1.timestamp})) {
            let coordItem: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            coords.append(coordItem)
                }
        loadMap()

    }

        private func mapRegion() -> MKCoordinateRegion? {

            let latitudes = coords.map { location -> Double in
                let location = location
                return location.latitude
            }

            let longitudes = coords.map { location -> Double in
                let location = location
                return location.longitude
            }

            let maxLat = latitudes.max()!
            let minLat = latitudes.min()!
            let maxLong = longitudes.max()!
            let minLong = longitudes.min()!
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3)

            return MKCoordinateRegion(center: center, span: span)
        }

        private func loadMap() {
            guard
                coords.count > 0,
                let region = mapRegion()
                else {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Sorry, this activity has no locations saved",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(alert, animated: true)
                    return
            }
            mapView.setRegion(region, animated: true)
            mapView.add(polyLine())
        }

        private func polyLine() -> MKPolyline {
            return MKPolyline(coordinates: coords, count: coords.count)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }

            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .purple
            renderer.lineWidth = 3
            return renderer
        }

}
