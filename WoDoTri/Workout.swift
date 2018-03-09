//  Copyright © 2017 Markus Staas. All rights reserved.

import Foundation
import CoreLocation

final class Workout {

    // TODO: Make this class into value type
    // TODO: Delete stop watch and workout state
    // TODO: Handle start of started and pause of paused
    // TODO: Make addDistance and co private?
    // TODO: Rename startDate to currentLapStartDate
    // TODO: Rename previousDuration to durationOfPreviousLaps

    let workoutType: WorkoutType

    private var locationsForCurrentLap: Set<CLLocation> = []
    private var locationsForPreviousLaps: Set<CLLocation> = []

    private var startDate: Date?
    private var previousDuration = Measurement(value: 0, unit: UnitDuration.seconds)

    private(set) var distance = Workout.initialDistance
    private(set) var distanceText = Workout.makeDistanceText(for: Workout.initialDistance)

    private static let initialDistance = Measurement(value: 0, unit: UnitLength.meters)

    // MARK: - Creating Workout

    init(workoutType: WorkoutType) {
        self.workoutType = workoutType
    }

    // MARK: - Starting and Pausing Workout

    func start() {
        startDate = Date()
    }

    func pause() {
        previousDuration = duration
        locationsForPreviousLaps.formUnion(locationsForCurrentLap)
        locationsForCurrentLap.removeAll()
        startDate = nil
    }

    // MARK: - Managing Locations

    func addLocation(_ location: CLLocation) {
        let sortedLocationsForCurrentLap = locationsForCurrentLap.sorted { location, otherLocation in
            location.timestamp > otherLocation.timestamp
        }
        if let lastLocation = sortedLocationsForCurrentLap.last, startDate != nil {
            let delta = location.distance(from: lastLocation)
            let deltaMeasurement = Measurement(value: delta, unit: UnitLength.meters)
            addDistance(deltaMeasurement)
        }
        locationsForCurrentLap.insert(location)
    }

    var locations: Set<CLLocation> {
        return locationsForCurrentLap.union(locationsForPreviousLaps)
    }

    // MARK: - Managing Duration

    var duration: Measurement<UnitDuration> {
        guard let startDate = startDate else { return previousDuration }
        let currentDurationInSeconds = Date().timeIntervalSince(startDate)
        let currentDuration = Measurement(value: currentDurationInSeconds, unit: UnitDuration.seconds)
        return previousDuration + currentDuration
    }

    var durationText: String {
        return Workout.makeDurationText(for: duration)
    }

    static func makeDurationText(for duration: Measurement<UnitDuration>) -> String {
        let seconds = duration.converted(to: UnitDuration.seconds).value
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds)!
    }

    // MARK: - Managing Distance

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
