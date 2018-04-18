//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class WorkoutLocation: NSManagedObject {

    @NSManaged private(set) var isWorkoutPaused: Bool
    @NSManaged private(set) var latitude: Double
    @NSManaged private(set) var longitude: Double
    @NSManaged private(set) var timestamp: Date
    @NSManaged private(set) var currentInWorkout: Workout?
    @NSManaged private(set) var workout: Workout

    // MARK: - Creating Workout Location

    convenience init(currentIn workout: Workout, location: CLLocation) {
        self.init(entity: WorkoutLocation.entity(), insertInto: workout.managedObjectContext)
        isWorkoutPaused = workout.isPaused
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        timestamp = location.timestamp
        currentInWorkout = workout
        self.workout = workout
    }

    // MARK: - Calculating Distances

    func distance(from otherWorkoutLocation: WorkoutLocation) -> Double {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let otherLocation = CLLocation(latitude: otherWorkoutLocation.latitude, longitude: otherWorkoutLocation.longitude)
        return location.distance(from: otherLocation)
    }

}
