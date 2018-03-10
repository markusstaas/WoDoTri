//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData

final class WorkoutLocation: NSManagedObject {

    @NSManaged private(set) var isWorkoutPaused: Bool
    @NSManaged private(set) var latitude: Double
    @NSManaged private(set) var longitude: Double
    @NSManaged private(set) var date: Date
    @NSManaged private(set) var workout: Workout

}
