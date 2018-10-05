//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import MapKit
import CoreData

protocol WorkoutLogDetailViewControllerDataSource: AnyObject {

    func workoutType(for workoutLogDetailViewController: WorkoutLogDetailViewControllerDataSource) -> WorkoutType
    func workoutDistance(for workoutLogDetailViewController: WorkoutLogDetailViewControllerDataSource) -> Double
    func workoutDuration(for workoutLogDetailViewController: WorkoutLogDetailViewControllerDataSource) -> Double

}

final class WorkoutLogDetailViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var workoutTypeLabel: UILabel!
    private var coords = [CLLocationCoordinate2D]()

    weak var dataSource: WorkoutLogDetailViewControllerDataSource!
    var workout: NSManagedObject!

    private lazy var durationFormatter = DurationFormatter(dataSource: self)
    private lazy var averageVelocityFormatter = VelocityFormatter(dataSource: self, delegate: self)
    private lazy var distanceFormatter = DistanceFormatter(dataSource: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MeasurementTableViewCell.preferredNib, forCellReuseIdentifier: MeasurementTableViewCell.preferredReuseIdentifier)
        updateView()
        mapView.delegate = self
        let locations = workout.value(forKey: "locationHistory") as? Set<WorkoutLocation>
        for location in (locations?.sorted(by: ({$0.timestamp < $1.timestamp})))! {
            let coordItem: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            coords.append(coordItem)
        }
        if coords.count <= 0 {

        } else {
            loadMap()
        }
    }

    func updateView() {
        updateDurationIfVisible()
        updateAverageVelocityIfVisible()
        updateDistanceIfVisible()
        let workoutTypeDescriptionText = workout.value(forKeyPath: "workoutTypeDescription") as? String
        workoutTypeLabel.text = workoutTypeDescriptionText?.capitalized
    }

    private func updateDurationIfVisible() {
        let indexPath = IndexPath(row: 1, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        guard let measurementCell = cell as? MeasurementTableViewCell else {
            fatalError("Invalid table view cell.")
        }
        measurementCell.updateMeasurement(property: durationFormatter.property, value: durationFormatter.value, unit: nil)
    }

    private func updateAverageVelocityIfVisible() {
        let indexPath = IndexPath(row: 2, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        guard let measurementCell = cell as? MeasurementTableViewCell else {
            fatalError("Invalid table view cell")
        }
        measurementCell.updateMeasurement(property: averageVelocityFormatter.property, value: averageVelocityFormatter.value, unit: averageVelocityFormatter.unit)
    }

    private func updateDistanceIfVisible() {
        let indexPath = IndexPath(row: 3, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        guard let measurementCell = cell as? MeasurementTableViewCell else {
            fatalError("Invalid table view cell.")
        }
        measurementCell.updateMeasurement(property: distanceFormatter.property, value: distanceFormatter.value, unit: distanceFormatter.unit)
    }

}

// MARK: - Managing UITableView

extension WorkoutLogDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementTableViewCell.preferredReuseIdentifier, for: indexPath) as? MeasurementTableViewCell else {
            fatalError("Invalid table view cell.")
        }
        switch indexPath.row {
        case 0: cell.updateMeasurement(property: durationFormatter.property, value: durationFormatter.value, unit: nil)
        case 1: cell.updateMeasurement(property: averageVelocityFormatter.property, value: averageVelocityFormatter.value, unit: averageVelocityFormatter.unit)
        case 2: cell.updateMeasurement(property: distanceFormatter.property, value: distanceFormatter.value, unit: distanceFormatter.unit)
        default: fatalError()
        }
        return cell
    }

}

// MARK: - Managing MapView

extension WorkoutLogDetailViewController: MKMapViewDelegate {

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

// MARK: - Managing VelocityFormatter

extension WorkoutLogDetailViewController: VelocityFormatterDataSource {
    func instantVelocity(for velocityFormatter: VelocityFormatter) -> Double {
        return (workout.value(forKeyPath: "duration") as? Double)!
    }

    func duration(for velocityFormatter: VelocityFormatter) -> Double {
        return (workout.value(forKeyPath: "duration") as? Double)!
    }

    func distance(for velocityFormatter: VelocityFormatter) -> Double {
        return (workout.value(forKeyPath: "distance") as? Double)!
    }

}

extension WorkoutLogDetailViewController: VelocityFormatterDelegate {

    func propertyType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.PropertyType {
            return .averageVelocity
    }

    func unitType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.UnitType {
        let workoutType = workout.value(forKeyPath: "workoutTypeDescription") as? String
        switch workoutType {
        case "ride":
            return .distancePerDuration
        case "run":
            return .durationPerDistance
        case .none:
            return .distancePerDuration
        case .some(_):
            return .distancePerDuration
        }
    }

}

// MARK: - Managing DistanceFormatter

extension WorkoutLogDetailViewController: DistanceFormatterDataSource {

    func distance(for distanceFormatter: DistanceFormatter) -> Double {
        return (workout.value(forKeyPath: "distance") as? Double)!
    }

}

// MARK: - Managing DurationFormatter

extension WorkoutLogDetailViewController: DurationFormatterDataSource {

    func duration(for durationFormatter: DurationFormatter) -> Double {
        return (workout.value(forKeyPath: "duration") as? Double)!
    }

}
