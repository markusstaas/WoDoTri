import Foundation

protocol DurationFormatterDataSource: AnyObject {

    func duration(for durationFormatter: DurationFormatter) -> Double

}

final class DurationFormatter {

    weak var dataSource: DurationFormatterDataSource?
    private let valueFormatter = DateComponentsFormatter()

    init(dataSource: DurationFormatterDataSource) {
        self.dataSource = dataSource
    }

    var property: String {
        return NSLocalizedString("Duration", comment: "")
    }

    var value: String {
        guard let duration = dataSource?.duration(for: self) else {
            assertionFailure()
            return ""
        }
        valueFormatter.allowedUnits = [.hour, .minute, .second]
        valueFormatter.zeroFormattingBehavior = .pad
        return valueFormatter.string(from: duration)!
    }

}
