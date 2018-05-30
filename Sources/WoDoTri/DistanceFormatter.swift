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
        return NSLocalizedString("Distance", comment: "")
    }

    var value: String {
        guard let dataSource = dataSource else {
            return ""
        }
        let distanceDivisor = Locale.current.usesMetricSystem ? 1000 : 1609.344
        let distance = dataSource.distance(for: self) / distanceDivisor
        let valueNumber = NSNumber(value: distance)
        valueFormatter.numberStyle = .decimal
        valueFormatter.minimumFractionDigits = 2
        valueFormatter.maximumFractionDigits = 2
        return valueFormatter.string(from: valueNumber) ?? ""
    }

    var unit: String {
        return Locale.current.usesMetricSystem
            ? NSLocalizedString("km", comment: "")
            : NSLocalizedString("mi", comment: "")
    }

}
