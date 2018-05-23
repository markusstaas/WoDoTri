import Foundation

protocol VelocityFormatterDataSource: AnyObject {

    func duration(for velocityFormatter: VelocityFormatter) -> Double
    func distance(for velocityFormatter: VelocityFormatter) -> Double

}

protocol VelocityFormatterDelegate: AnyObject {

    func unitType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.UnitType

}

final class VelocityFormatter {

    enum UnitType {
        case distancePerDuration
        case durationPerDistance
    }

    unowned var dataSource: VelocityFormatterDataSource
    unowned var delegate: VelocityFormatterDelegate

    private let valueFormatter = NumberFormatter()

    // MARK: - Creating Velocity Formatter

    init(dataSource: VelocityFormatterDataSource, delegate: VelocityFormatterDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }

    // MARK: - Providing Formatted Data

    var property: String {
        let unitType = delegate.unitType(for: self)

        switch unitType {
        case .distancePerDuration:
            return NSLocalizedString("Speed", comment: "")
        case .durationPerDistance:
            return NSLocalizedString("Pace", comment: "")
        }
    }

    var value: String {
        let unitType = delegate.unitType(for: self)
        let isMetric = Locale.current.usesMetricSystem

        let distanceDivisor: Double
        let durationDivisor: Double

        switch (unitType, isMetric) {
        case (.distancePerDuration, true):
            distanceDivisor = 1000
            durationDivisor = 3600
        case (.distancePerDuration, false):
            distanceDivisor = 1609.344
            durationDivisor = 3600
        case (.durationPerDistance, true):
            distanceDivisor = 1000
            durationDivisor = 60
        case (.durationPerDistance, false):
            distanceDivisor = 1609.344
            durationDivisor = 60
        }

        let distance = dataSource.distance(for: self) / distanceDivisor
        let duration = dataSource.duration(for: self) / durationDivisor

        let value = duration != 0 ? distance / duration : 0
        let valueNumber = NSNumber(value: value)

        return valueFormatter.string(from: valueNumber)!
    }

    var unit: String {
        let unitType = delegate.unitType(for: self)
        let isMetric = Locale.current.usesMetricSystem

        switch (unitType, isMetric) {
        case (.distancePerDuration, true):
            return NSLocalizedString("km/h", comment: "")
        case (.distancePerDuration, false):
            return NSLocalizedString("mph", comment: "")
        case (.durationPerDistance, true):
            return NSLocalizedString("min/km", comment: "")
        case (.durationPerDistance, false):
            return NSLocalizedString("min/mile", comment: "")
        }
    }

}
