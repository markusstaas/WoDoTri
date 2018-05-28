import UIKit

// swiftlint:disable force_cast

protocol WorkoutDataViewControllerDataSource: AnyObject {

    func workoutType(for workoutDataViewController: WorkoutDataViewController) -> WorkoutType
    func workoutDistance(for workoutDataViewController: WorkoutDataViewController) -> Double
    func workoutDuration(for workoutDataViewController: WorkoutDataViewController) -> Double

}

final class WorkoutDataViewController: UITableViewController, VelocityFormatterDataSource, VelocityFormatterDelegate, DistanceFormatterDataSource, DurationFormatterDataSource {

    weak var dataSource: WorkoutDataViewControllerDataSource!

    private lazy var velocityFormatter = VelocityFormatter(dataSource: self, delegate: self)
    private lazy var durationFormatter = DurationFormatter(dataSource: self)
    private lazy var averageVelocityFormatter = VelocityFormatter(dataSource: self, delegate: self)
    private lazy var distanceFormatter = DistanceFormatter(dataSource: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MeasurementTableViewCell.preferredNib, forCellReuseIdentifier: MeasurementTableViewCell.preferredReuseIdentifier)
    }

    // MARK: - Managing Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementTableViewCell.preferredReuseIdentifier, for: indexPath) as! MeasurementTableViewCell

        switch indexPath.row {
        case 0: // Speed
             cell.updateMeasurement(property: velocityFormatter.property, value: velocityFormatter.value, unit: velocityFormatter.unit)
        case 1: // Time
            cell.updateMeasurement(property: durationFormatter.property, value: durationFormatter.value, unit: durationFormatter.unit)
        case 2: // Avg. Speed
            cell.updateMeasurement(property: averageVelocityFormatter.property, value: averageVelocityFormatter.value, unit: averageVelocityFormatter.unit)
        case 3: // Distance
            cell.updateMeasurement(property: distanceFormatter.property, value: distanceFormatter.value, unit: distanceFormatter.unit)
        default:
            fatalError()
        }

        return cell
    }

//    override init() {
//        super.init()
//        self.displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
//        displayLink.isPaused = true
//        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
//        self.elapsedTime = 0.0
//        formatter.timeZone = TimeZone(abbreviation: "GMT")!
//        formatter.dateFormat = "HH:mm:ss"
//    }
//
//    deinit {
//        displayLink.invalidate()
//    }
//    @objc private func tick(sender: CADisplayLink) {
//        elapsedTime = elapsedTime + displayLink.duration
//        callback?()
//    }

    // MARK: - Managing Velocity Formatter

    func duration(for velocityFormatter: VelocityFormatter) -> Double {
        return dataSource.workoutDuration(for: self)
    }

    func distance(for velocityFormatter: VelocityFormatter) -> Double {
        return dataSource.workoutDistance(for: self)
    }

    func propertyType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.PropertyType {
        if velocityFormatter === self.velocityFormatter {
            return .velocity
        } else if velocityFormatter === averageVelocityFormatter {
            return .averageVelocity
        } else {
            fatalError()
        }
    }

    func unitType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.UnitType {
        let workoutType = dataSource.workoutType(for: self)
        switch workoutType {
        case .ride:
            return .distancePerDuration
        case .run:
            return .durationPerDistance
        }
    }
    // MARK: - Managing Duration Formatter
    func duration(for durationFormatter: DurationFormatter) -> Double {
        return dataSource.workoutDuration(for: self)
    }

    // MARK: - Managing Distance Formatter

    func distance(for distanceFormatter: DistanceFormatter) -> Double {
        return dataSource.workoutDistance(for: self)
    }
}
