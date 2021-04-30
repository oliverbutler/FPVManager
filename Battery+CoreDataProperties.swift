//
//  Battery+CoreDataProperties.swift
//  
//
//  Created by Oliver Butler on 30/04/2021.
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
    @NSManaged public var cycleCount: Float
    @NSManaged public var notes: String?
    @NSManaged public var number: Int64
    @NSManaged public var voltage: Float
    @NSManaged public var aircrafts: NSSet?
    @NSManaged public var batteryEvents: NSSet?
    @NSManaged public var batteryType: BatteryType?
    
    
    public var cellVoltage: Float {
        voltage / Float(cellCount);
    }

}

// MARK: Generated accessors for aircrafts
extension Battery {

    @objc(addAircraftsObject:)
    @NSManaged public func addToAircrafts(_ value: Aircraft)

    @objc(removeAircraftsObject:)
    @NSManaged public func removeFromAircrafts(_ value: Aircraft)

    @objc(addAircrafts:)
    @NSManaged public func addToAircrafts(_ values: NSSet)

    @objc(removeAircrafts:)
    @NSManaged public func removeFromAircrafts(_ values: NSSet)

}

// MARK: Generated accessors for batteryEvents
extension Battery {

    @objc(addBatteryEventsObject:)
    @NSManaged public func addToBatteryEvents(_ value: BatteryEvent)

    @objc(removeBatteryEventsObject:)
    @NSManaged public func removeFromBatteryEvents(_ value: BatteryEvent)

    @objc(addBatteryEvents:)
    @NSManaged public func addToBatteryEvents(_ values: NSSet)

    @objc(removeBatteryEvents:)
    @NSManaged public func removeFromBatteryEvents(_ values: NSSet)

}
