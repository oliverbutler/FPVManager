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
public func newBatteryEvent(batt: Battery, endVoltage: Float) {
    let viewContext = PersistenceController.shared.container.viewContext;
    
    // Create and populate a new BatteryEvent
    let event: BatteryEvent = BatteryEvent(context: viewContext);
    event.startVoltage = batt.voltage;
    event.endVoltage = endVoltage;
    event.timestamp = Date();
    
    // Add the event to the battery
    batt.addToBatteryEvents(event);
    
    // Calculate the cycles
    let cycles = getCycles(batt: batt, newVoltage: endVoltage);
    batt.cycleCount += cycles;
    
    // Set the battery voltage MUST be after we calculate cycles
    batt.voltage = endVoltage;
        
    PersistenceController.shared.save();
}


/**
    Return the cycles of changing a current battery state to a new voltage, if the voltage increased return 0.
 
    Voltage is TOTAL voltage
 */
public func getCycles(batt: Battery, newVoltage: Float) -> Float {
    if(newVoltage >= batt.voltage) { return 0; }
    return 1.0 - (newVoltage/Float(batt.cellCount) - batt.batteryType!.cellMinVoltage) / (batt.batteryType!.cellMaxVoltage - batt.batteryType!.cellMinVoltage)
}

