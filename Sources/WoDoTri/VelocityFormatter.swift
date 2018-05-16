import Foundation

protocol VelocityFormatterDataSource: AnyObject {

    func duration(for velocityFormatter: VelocityFormatter) -> Double
    func distance(for velocityFormatter: VelocityFormatter) -> Double

}

protocol VelocityFormatterDelegate: AnyObject {

    func outputType(for velocityFormatter: VelocityFormatter) -> VelocityFormatter.OutputType

}

final class VelocityFormatter {

    enum OutputType {
        case distancePerTime
        case timePerDistance
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
        let outputType = delegate.outputType(for: self)

        switch outputType {
        case .distancePerTime:
            return NSLocalizedString("Speed", comment: "")
        case .timePerDistance:
            return NSLocalizedString("Pace", comment: "")
        }
    }

    var value: String {
        let outputType = delegate.outputType(for: self)
        let isMetric = Locale.current.usesMetricSystem

        let distanceDivisor: Double
        let durationDivisor: Double

        switch (outputType, isMetric) {
        case (.distancePerTime, true):
            distanceDivisor = 1000
            durationDivisor = 3600
        case (.distancePerTime, false):
            distanceDivisor = 1609.344
            durationDivisor = 3600
        case (.timePerDistance, true):
            distanceDivisor = 1000
            durationDivisor = 60
        case (.timePerDistance, false):
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
        let outputType = delegate.outputType(for: self)
        let isMetric = Locale.current.usesMetricSystem

        switch (outputType, isMetric) {
        case (.distancePerTime, true):
            return NSLocalizedString("km/h", comment: "")
        case (.distancePerTime, false):
            return NSLocalizedString("mph", comment: "")
        case (.timePerDistance, true):
            return NSLocalizedString("min/km", comment: "")
        case (.timePerDistance, false):
            return NSLocalizedString("min/mile", comment: "")
        }
    }

}
