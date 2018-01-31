import Foundation
import CoreData

@objc(Location)
final class Location: NSManagedObject {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var timestamp: Date
    @NSManaged var activity: Activity

}
