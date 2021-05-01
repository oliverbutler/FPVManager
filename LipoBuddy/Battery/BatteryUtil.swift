//
//  BatteryUtil.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import Foundation
import CoreData
import SwiftUI

/**
 Create a new BatteryEvent for a battery
 */
public func addBatteryEvent(viewContext: NSManagedObjectContext, batt: Battery, newCellVoltage: Float) {
//    let viewContext = PersistenceController.shared.container.viewContext;
    
    // Create and populate a new BatteryEvent
    let event: BatteryEvent = BatteryEvent(context: viewContext);
    event.startCellVoltage = batt.cellVoltage;
    event.endCellVoltage = newCellVoltage;
    event.timestamp = Date();
    
    // Add the event to the battery
    batt.addToBatteryEvents(event);
    
    // Calculate the cycles
    let cycles = getCycles(batt: batt, newCellVoltage: newCellVoltage);
    
    batt.cycleCount += cycles;
    
    // Set the battery voltage MUST be after we calculate cycles
    batt.cellVoltage = newCellVoltage;
    
    
    
    
    PersistenceController.shared.save();
}


/**
    Return the cycles of changing a current battery state to a new voltage, if the voltage increased return 0.
 */
public func getCycles(batt: Battery, newCellVoltage: Float) -> Float {
    return max(0, (batt.cellVoltage - newCellVoltage) / (batt.batteryType!.cellMaxVoltage - batt.batteryType!.cellMinVoltage))
}

/**
 Returns an example battery
 */
public func getExampleBattery() -> Battery {
    let viewContext = PersistenceController.shared.container.viewContext;
    
    let battery: Battery = Battery(context: viewContext);
    battery.name = "B1"
    battery.cellCount = 4
    battery.capacity = 1400
    battery.createdTimestamp = Date();
    battery.cycleCount = 0;
    battery.notes = "This is an example battery"
    battery.cellVoltage = 4.2
    
    let batteryType: BatteryType = BatteryType(context: viewContext);
    batteryType.name = "LiPo";
    batteryType.cellStorageVoltage = 3.8;
    batteryType.cellMaxVoltage = 4.2;
    batteryType.cellMinVoltage = 3.3;
    
    battery.batteryType = batteryType;
    
    addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 3.8);
    addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 3.3);
    addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 4.2);
    
    return battery;
}
