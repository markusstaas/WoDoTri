//  Copyright © 2017 Markus Staas. All rights reserved.

import Foundation
import CoreLocation

final class Workout {

    static let shared = Workout()
    private var stopwatch = StopWatch()

    var activityType = WorkoutType.run
    var activityState = WorkoutState.notStarted
    var avgPace: String
    var locationList: [CLLocation] = []
    var duration = 0.00
    var durationString = ""

    private(set) var distance = Workout.initialDistance
    private(set) var distanceText = Workout.makeDistanceText(for: Workout.initialDistance)

    private static let initialDistance = Measurement(value: 0, unit: UnitLength.meters)

    init() {
        self.avgPace = ""
        self.durationString = stopwatch.elapsedTimeAsString()
    }

    func avgPaceString() -> String {
        self.avgPace = FormatDisplay.avgPace(
            distance: distance,
            seconds: Int(duration),
            outputUnit: UnitSpeed.minutesPerMile
        )
        return avgPace
    }

    // MARK: - Updating distance

    func addDistance(_ newDistance: Measurement<UnitLength>) {
        setDistance(distance + newDistance)
    }

    func resetDistance() {
        setDistance(Workout.initialDistance)
    }

    private func setDistance(_ newDistance: Measurement<UnitLength>) {
        distance = newDistance
        distanceText = Workout.makeDistanceText(for: newDistance)
    }

    static func makeDistanceText(for distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 2
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter.string(from: distance)
    }

}
