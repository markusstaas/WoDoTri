//
//  Activity+CoreDataProperties.swift
//  WoDoTri
//
//  Created by Markus Staas on 2/1/18.
//  Copyright © 2018 Markus Staas. All rights reserved.
//
//

import Foundation
import CoreData

extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var distance: Double
    @NSManaged public var duration: Double
    @NSManaged public var durationString: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Activity {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
