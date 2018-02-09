//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData

final class Activity: NSManagedObject {

    static let entityName = String(describing: self)

    @NSManaged var distance: Double
    @NSManaged var duration: Double
    @NSManaged var durationString: String?
    @NSManaged var timestamp: Date?
    @NSManaged var type: String?
    @NSManaged var locations: Set<Location>

    @objc(addLocationsObject:)
    @NSManaged func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged func addToLocations(_ values: Set<Location>)

    @objc(removeLocations:)
    @NSManaged func removeFromLocations(_ values: Set<Location>)

    static func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: entityName)
    }

}
