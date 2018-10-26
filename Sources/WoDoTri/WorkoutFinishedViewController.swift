//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit
import CoreData
import MapKit

protocol WorkoutFinishedViewControllerDataSource: AnyObject {

    func workoutType(for workoutFinishedViewController: WorkoutFinishedViewController) -> WorkoutType
    func workoutDistance(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutDuration(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutLocationHistory(for workoutFinishedViewController: WorkoutFinishedViewController) -> Set<WorkoutLocation>
    func workoutStartedAt(for workoutFisnishedViewController: WorkoutFinishedViewController) -> Date
}

class WorkoutFinishedViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private var gpxFormatter: GPXFormatter?
    private var gpxUploader: GPXUploader?
    private var coords = [CLLocationCoordinate2D]()
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var dataSource: WorkoutFinishedViewControllerDataSource?
    private let homeViewControllerSegueIdentifier = "Home View Controller Segue"

    @IBAction func saveWorkoutToLog(_ sender: Any) {
        appDelegate?.saveContext()
        performSegue(withIdentifier: homeViewControllerSegueIdentifier, sender: self)
    }

    @IBAction func shareWorkout(_ sender: Any) {
        checkForInternetConnection()
    }

    @IBAction func deleteWorkout(_ sender: Any) {
        let alert = UIAlertController(title: "Discard Workout?", message: "Please confirm that you want to discard this workout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard", comment: "Default action"), style: .destructive, handler: { _ in
            let workoutEntity = NSEntityDescription.entity(forEntityName: "Workout", in: (self.appDelegate?.persistentContainer.viewContext)!)
            let workoutObject = NSManagedObject(entity: workoutEntity!, insertInto: self.appDelegate?.persistentContainer.viewContext)
            self.appDelegate?.persistentContainer.viewContext.delete(workoutObject)
            self.appDelegate?.persistentContainer.viewContext.reset()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Action"), style: .cancel, handler: { _ in
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locations = dataSource!.workoutLocationHistory(for: self)
        for location in locations.sorted(by: ({$0.timestamp < $1.timestamp})) {
            let coordItem: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            coords.append(coordItem)
                }
        if coords.count <= 0 {

        } else {
            loadMap()
        }
    }

    private func checkForInternetConnection() {
        if CheckInternetConnection.checkIfConnected() {
            shareWorkout()
        } else {
            let alert = UIAlertController(title: "No Internet Conection", message: "To share this workout you need to be connected to the Internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func shareWorkout() {
        gpxFormatter = GPXFormatter(workoutType: (dataSource?.workoutType(for: self))!, locationHistory: (dataSource?.workoutLocationHistory(for: self))!, workoutStartedAt: (dataSource?.workoutStartedAt(for: self))!)
        GPXUploader(gpxString: (gpxFormatter?.makeGPX())!).uploadWorkoutToStrava()
        performSegue(withIdentifier: homeViewControllerSegueIdentifier, sender: self)
    }
}

// MARK: - Managing MapView

extension WorkoutFinishedViewController: MKMapViewDelegate {

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
        if let region = mapRegion() {
            mapView.setRegion(region, animated: true)
            mapView.addOverlay(polyLine())
        }
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
