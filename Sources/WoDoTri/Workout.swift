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

}
