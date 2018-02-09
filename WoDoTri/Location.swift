//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData

final class Location: NSManagedObject {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var timestamp: Date
    @NSManaged var activity: Activity

}
