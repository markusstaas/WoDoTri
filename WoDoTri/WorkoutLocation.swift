//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData
import CoreLocation

final class WorkoutLocation: NSManagedObject {

    @NSManaged private(set) var isWorkoutPaused: Bool
    @NSManaged private(set) var latitude: Double
    @NSManaged private(set) var longitude: Double
    @NSManaged private(set) var date: Date
    @NSManaged private(set) var workout: Workout

    static func insert(into workout: Workout, location: CLLocation) {
        let workoutLocation = WorkoutLocation(entity: entity(), insertInto: workout.managedObjectContext)
        workoutLocation.isWorkoutPaused = workout.isPaused
        workoutLocation.latitude = location.coordinate.latitude
        workoutLocation.longitude = location.coordinate.longitude
        workoutLocation.date = location.timestamp
        workoutLocation.workout = workout
    }

}
