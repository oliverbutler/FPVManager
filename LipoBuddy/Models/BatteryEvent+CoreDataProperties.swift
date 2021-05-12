//
//  BatteryEvent+CoreDataProperties.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//
//

import Foundation
import CoreData


extension BatteryEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BatteryEvent> {
        return NSFetchRequest<BatteryEvent>(entityName: "BatteryEvent")
    }

    @NSManaged public var endCellVoltage: Float
    @NSManaged public var startCellVoltage: Float
    @NSManaged public var timestamp: Date?
    @NSManaged public var flight: Flight?

}

extension BatteryEvent : Identifiable {

}
