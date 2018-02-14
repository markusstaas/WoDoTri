//  Copyright © 2017 Markus Staas. All rights reserved.
import Foundation

struct FormatDisplay {

    static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit] // 1
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: speed.converted(to: outputUnit))
    }

    static func avgPace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit] // 1
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: speed.converted(to: outputUnit))
    }

    static func date(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: timestamp)
    }

}
