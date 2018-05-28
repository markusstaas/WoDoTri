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

        let distanceDivisor: Double!

        if Locale.current.usesMetricSystem {
            distanceDivisor = 1000
        } else {
            distanceDivisor = 1609.344
        }

        let distance = dataSource.distance(for: self) / distanceDivisor
        let valueNumber = NSNumber(value: distance)
        valueFormatter.numberStyle = .decimal
        valueFormatter.minimumFractionDigits = 2
        valueFormatter.maximumFractionDigits = 2
        return valueFormatter.string(from: valueNumber)!
    }

    var unit: String {
        guard dataSource != nil else {
            assertionFailure()
            return ""
        }

        if Locale.current.usesMetricSystem {
            return NSLocalizedString("km", comment: "")
        } else {
            return NSLocalizedString("mi", comment: "")
        }
    }

}
