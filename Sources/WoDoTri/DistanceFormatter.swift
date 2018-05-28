import Foundation

protocol DistanceFormatterDataSource: AnyObject {

    func distance(for distanceFormatter: DistanceFormatter) -> Double

}

final class DistanceFormatter {

    weak var dataSource: DistanceFormatterDataSource?

    private let valueFormatter = NumberFormatter()

    init(dataSource: DistanceFormatterDataSource) {
        self.dataSource = dataSource
    }

    var property: String {
        guard dataSource != nil else {
            assertionFailure()
            return ""
        }
        return NSLocalizedString("Distance", comment: "")
    }

    var value: String {
        guard let dataSource = dataSource else {
            assertionFailure()
            return ""
        }

        let isMetric = Locale.current.usesMetricSystem
        let distanceDivisor: Double

        if isMetric {
            distanceDivisor = 1000
        } else {
            distanceDivisor = 1609.344
        }

        let distance = dataSource.distance(for: self) / distanceDivisor
        let valueNumber = NSNumber(value: distance)
        valueFormatter.numberStyle = .decimal
        return valueFormatter.string(from: valueNumber)!
    }

    var unit: String {
        guard dataSource != nil else {
            assertionFailure()
            return ""
        }

        let isMetric = Locale.current.usesMetricSystem

        if isMetric {
            return NSLocalizedString("km", comment: "")
        } else {
            return NSLocalizedString("mi", comment: "")
        }
    }

}
