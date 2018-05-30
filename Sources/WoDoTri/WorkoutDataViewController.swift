import UIKit

protocol WorkoutDataViewControllerDataSource: AnyObject {

    func workoutType(for workoutDataViewController: WorkoutDataViewController) -> WorkoutType
    func workoutDistance(for workoutDataViewController: WorkoutDataViewController) -> Double
    func workoutDuration(for workoutDataViewController: WorkoutDataViewController) -> Double

}

final class WorkoutDataViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    weak var dataSource: WorkoutDataViewControllerDataSource!

    private lazy var velocityFormatter = VelocityFormatter(dataSource: self, delegate: self)
    private lazy var durationFormatter = DurationFormatter(dataSource: self)
    private lazy var averageVelocityFormatter = VelocityFormatter(dataSource: self, delegate: self)
    private lazy var distanceFormatter = DistanceFormatter(dataSource: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MeasurementTableViewCell.preferredNib, forCellReuseIdentifier: MeasurementTableViewCell.preferredReuseIdentifier)
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
//
//    @objc private func tick(sender: CADisplayLink) {
//        elapsedTime = elapsedTime + displayLink.duration
//        callback?()
//    }

}

// MARK: - Managing UITableView

extension WorkoutDataViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementTableViewCell.preferredReuseIdentifier, for: indexPath) as? MeasurementTableViewCell else {
            fatalError("Unknown table view cell.")
        }
        switch indexPath.row {
        case 0: cell.updateMeasurement(property: velocityFormatter.property, value: velocityFormatter.value, unit: velocityFormatter.unit)
        case 1: cell.updateMeasurement(property: durationFormatter.property, value: durationFormatter.value, unit: nil)
        case 2: cell.updateMeasurement(property: averageVelocityFormatter.property, value: averageVelocityFormatter.value, unit: averageVelocityFormatter.unit)
        case 3: cell.updateMeasurement(property: distanceFormatter.property, value: distanceFormatter.value, unit: distanceFormatter.unit)
        default: fatalError()
        }
        return cell
    }

}

// MARK: - Managing VelocityFormatter

extension WorkoutDataViewController: VelocityFormatterDataSource {

    func duration(for velocityFormatter: VelocityFormatter) -> Double {
        return dataSource.workoutDuration(for: self)
    }

    func distance(for velocityFormatter: VelocityFormatter) -> Double {
        return dataSource.workoutDistance(for: self)
    }

}

extension WorkoutDataViewController: VelocityFormatterDelegate {

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

}

// MARK: - Managing DistanceFormatter

extension WorkoutDataViewController: DistanceFormatterDataSource {

    func distance(for distanceFormatter: DistanceFormatter) -> Double {
        return dataSource.workoutDistance(for: self)
    }

}

// MARK: - Managing DurationFormatter

extension WorkoutDataViewController: DurationFormatterDataSource {

    func duration(for durationFormatter: DurationFormatter) -> Double {
        return dataSource.workoutDuration(for: self)
    }

}
