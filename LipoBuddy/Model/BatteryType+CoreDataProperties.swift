//
//  BatteryType+CoreDataProperties.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//
//

import Foundation
import CoreData


extension BatteryType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BatteryType> {
        return NSFetchRequest<BatteryType>(entityName: "BatteryType")
    }

    @NSManaged public var cellChemistry: String?
    @NSManaged public var cellMaxVoltage: NSDecimalNumber?
    @NSManaged public var cellMinVoltage: NSDecimalNumber?
    @NSManaged public var cellStorageVoltage: NSDecimalNumber?
    @NSManaged public var name: String?

}

extension BatteryType : Identifiable {

}
