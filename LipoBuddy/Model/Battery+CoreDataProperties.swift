//
//  Battery+CoreDataProperties.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//
//

import Foundation
import CoreData


extension Battery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Battery> {
        return NSFetchRequest<Battery>(entityName: "Battery")
    }

    @NSManaged public var capacity: Int64
    @NSManaged public var cellCount: Int64
    @NSManaged public var createdTimestamp: Date?
    @NSManaged public var cycleCount: Int64
    @NSManaged public var id: Int64
    @NSManaged public var notes: String?
    @NSManaged public var voltage: NSDecimalNumber?
    @NSManaged public var batteryType: BatteryType?

}

extension Battery : Identifiable {

}
