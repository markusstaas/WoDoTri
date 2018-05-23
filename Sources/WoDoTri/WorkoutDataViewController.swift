import UIKit

// swiftlint:disable force_cast
// swiftlint:disable line_length

protocol WorkoutDataViewControllerDataSource: AnyObject {

    func workoutType(for workoutDataViewController: WorkoutDataViewController) -> WorkoutType
    func workoutDistance(for workoutDataViewController: WorkoutDataViewController) -> Double
    func workoutDuration(for workoutDataViewController: WorkoutDataViewController) -> Double

}

final class WorkoutDataViewController: UITableViewController, VelocityFormatterDataSource, VelocityFormatterDelegate {

    weak var dataSource: WorkoutDataViewControllerDataSource!

    private lazy var velocityFormatter = VelocityFormatter(dataSource: self, delegate: self)

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
            break
        case 1: // Time
            break
        case 2: // Avg. Speed
            cell.updateMeasurement(property: velocityFormatter.property, value: velocityFormatter.value, unit: velocityFormatter.unit)
        case 3: // Distance
            break
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
        return .averageVelocity
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

}
