//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class Workout: NSManagedObject {

    @NSManaged private var workoutTypeDescription: String
    @NSManaged private(set) var distance: Double
    @NSManaged private(set) var duration: Double
    @NSManaged private(set) var isPaused: Bool
    @NSManaged private(set) var lastStartedAt: Date?
    @NSManaged private(set) var currentLocation: WorkoutLocation?
    @NSManaged private(set) var locationHistory: Set<WorkoutLocation>

    private static let distanceFormatter = makeDistanceFormatter()
    private static let durationFormatter = makeDurationFormatter()

    // MARK: - Creating Workout

    convenience init(workoutType: WorkoutType, managedObjectContext: NSManagedObjectContext) {
        self.init(entity: Workout.entity(), insertInto: managedObjectContext)
        workoutTypeDescription = workoutType.rawValue
    }

    // MARK: - Providing Workout Type

    var workoutType: WorkoutType {
        return WorkoutType(rawValue: workoutTypeDescription)!
    }

    // MARK: - Starting and Pausing Workout

    func startWorkout() {
        lastStartedAt = Date()
        isPaused = false
    }

    func pauseWorkout() {
        guard let lastStartedAt = lastStartedAt else { return }
        isPaused = true
        duration += Date().timeIntervalSince(lastStartedAt)
    }

    // MARK: - Managing Locations

    func addLocation(_ location: CLLocation) {
        let oldLocationIfAvailable = currentLocation
        let newLocation = WorkoutLocation(currentIn: self, location: location)
        guard !isPaused else { return }
        guard let oldLocation = oldLocationIfAvailable else { return }
        distance += newLocation.distance(from: oldLocation)
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

    var durationText: String {
        return Workout.durationFormatter.string(from: duration)!
    }

    private static func makeDurationFormatter() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }

}
