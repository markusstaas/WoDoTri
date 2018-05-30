//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class Workout: NSManagedObject {

    @NSManaged private var workoutTypeDescription: String
    @NSManaged private(set) var distance: Double
    @NSManaged private var duration: Double
    @NSManaged var isPaused: Bool
    @NSManaged private(set) var currentLocation: WorkoutLocation?
    @NSManaged private(set) var locationHistory: Set<WorkoutLocation>
    @NSManaged private(set) var lastUpdatedDurationAt: Date?

    convenience init(workoutType: WorkoutType, managedObjectContext: NSManagedObjectContext) {
        self.init(entity: Workout.entity(), insertInto: managedObjectContext)
        workoutTypeDescription = workoutType.rawValue
    }

    var workoutType: WorkoutType {
        return WorkoutType(rawValue: workoutTypeDescription)!
    }

    func addLocation(_ location: CLLocation) {
        let oldLocationIfAvailable = currentLocation
        let newLocation = WorkoutLocation(currentIn: self, location: location)
        guard !isPaused else { return }
        guard let oldLocation = oldLocationIfAvailable else { return }
        distance += newLocation.distance(from: oldLocation)
    }

    func getDuration() -> TimeInterval {
        updateDuration()
        return duration
    }

    private func updateDuration() {
        guard !isPaused else {
            return
        }
        let now = Date()
        if let lastUpdatedDurationAtIfExists = lastUpdatedDurationAt {
            duration += now.timeIntervalSince(lastUpdatedDurationAtIfExists)
        }
        lastUpdatedDurationAt = now
    }

}
