//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class Workout: NSManagedObject {

    @NSManaged private var workoutTypeDescription: String
    @NSManaged private(set) var distance: Double
    @NSManaged private(set) var duration: Double
    @NSManaged var isPaused: Bool
    @NSManaged private(set) var currentLocation: WorkoutLocation?
    @NSManaged private(set) var locationHistory: Set<WorkoutLocation>
    @NSManaged private(set) var lastUpdatedDurationAt: Date?
    @NSManaged private(set) var workoutStartedAt: Date

    convenience init(workoutType: WorkoutType, managedObjectContext: NSManagedObjectContext) {
        self.init(entity: Workout.entity(), insertInto: managedObjectContext)
        workoutStartedAt = Date()
        workoutTypeDescription = workoutType.rawValue
    }

    var workoutType: WorkoutType {
        if let workoutType = WorkoutType(rawValue: workoutTypeDescription) {
            return workoutType
        } else {
            return .run
        }
    }

    func addLocation(_ location: CLLocation) {
        let oldLocationIfAvailable = currentLocation
        let newLocation = WorkoutLocation(currentIn: self, location: location)
        guard !isPaused else { return }
        guard let oldLocation = oldLocationIfAvailable else { return }
        distance += newLocation.distance(from: oldLocation)
    }

    func updateDuration() {
        guard !isPaused else {
            lastUpdatedDurationAt = Date()
            return
        }
        let now = Date()
        if let lastUpdatedDurationAtIfExists = lastUpdatedDurationAt {
            duration += now.timeIntervalSince(lastUpdatedDurationAtIfExists)
        }

        lastUpdatedDurationAt = now
    }
}
