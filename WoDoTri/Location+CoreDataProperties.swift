//
//  Location+CoreDataProperties.swift
//  WoDoTri
//
//  Created by Markus Staas on 2/1/18.
//  Copyright © 2018 Markus Staas. All rights reserved.
//
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date
    @NSManaged public var activity: Activity

}
