//  Copyright © 2017 Markus Staas. All rights reserved.

import Foundation
import CoreLocation

final class WorkoutData {

    static let shared = WorkoutData()
    private var stopwatch = StopWatch()

    var activityType = ActivityType.run
    var activityState = WorkoutState.notStarted
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var distanceFormatted: String
    var avgPace: String
    var locationList: [CLLocation] = []
    var duration = 0.00
    var durationString = ""

    init() {
        self.distanceFormatted = ""
        self.avgPace = ""
        self.durationString = stopwatch.elapsedTimeAsString()
    }

    func distanceString() -> String {
        self.distanceFormatted = FormatDisplay.distance(distance)
        return distanceFormatted
    }

    func avgPaceString() -> String {
        self.avgPace = FormatDisplay.avgPace(
            distance: distance,
            seconds: Int(duration),
            outputUnit: UnitSpeed.minutesPerMile)
        return avgPace
    }

}
