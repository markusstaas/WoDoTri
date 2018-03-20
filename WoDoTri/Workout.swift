//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class Workout: NSManagedObject {

    private static let entityName = String(describing: self)

    @NSManaged private var type: String
    @NSManaged private(set) var isPaused: Bool
    @NSManaged private var distance: Double
    @NSManaged private var duration: Double
    @NSManaged private var lastUpdatedAt: Date
    @NSManaged private var lastLatitude: Double
    @NSManaged private var lastLongitude: Double
    @NSManaged private var locations: Set<WorkoutLocation>

    private static var distanceFormatter = makeDistanceFormatter()

//    // MARK: - Creating Workout
//
//    init(workoutType: WorkoutType) {
//        self.workoutType = workoutType
//    }
//
    // MARK: - Starting and Pausing Workout

    func setWorkoutPaused(_ paused: Bool) {
        precondition(isPaused != paused)
        isPaused = paused
        lastUpdatedAt = Date()
    }

    // MARK: - Managing Locations

    func addLocation(_ location: CLLocation) {
        WorkoutLocation.insert(into: self, location: location)
        if !isPaused && !locations.isEmpty {
            let lastLocation = CLLocation(latitude: lastLatitude, longitude: lastLongitude)
            distance += location.distance(from: lastLocation)
        }
        lastLatitude = location.coordinate.latitude
        lastLongitude = location.coordinate.longitude
        lastUpdatedAt = Date()
    }

    // MARK: - Managing Distance

    var distanceText: String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        let distanceFormatter = Workout.distanceFormatter
        return distanceFormatter.string(from: distanceMeasurement)
    }

    private static func makeDistanceFormatter() -> MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 2
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter
    }

    // MARK: - Managing Duration


//    var duration: Measurement<UnitDuration> {
//        guard let startDate = startDate else { return previousDuration }
//        let currentDurationInSeconds = Date().timeIntervalSince(startDate)
//        let currentDuration = Measurement(value: currentDurationInSeconds, unit: UnitDuration.seconds)
//        return previousDuration + currentDuration
//    }
//
//    var durationText: String {
//        return Workout.makeDurationText(for: duration)
//    }
//
//    static func makeDurationText(for duration: Measurement<UnitDuration>) -> String {
//        let seconds = duration.converted(to: UnitDuration.seconds).value
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        return formatter.string(from: seconds)!
//    }

}
