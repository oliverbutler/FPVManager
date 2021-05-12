//
//  Battery+CoreDataClass.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 29/04/2021.
//
//

import Foundation
import CoreData

public enum BatteryStatus {
    case danger, low, storage, charged;
}

@objc(Battery)
public class Battery: NSManagedObject {
    
    /**
     Computed property for "voltage", allows getting and setting.
     */
    public var voltage: Float {
        get {
            cellVoltage * Float(cellCount);
        }
        set(newVoltage) {
            cellVoltage = newVoltage / Float(cellCount);
        }
    }
    
    /**
     Return the dynamic status of a battery based upon it's type.
     */
    public var status: BatteryStatus {
        
        let tol: Float = 0.1;
        
        if cellVoltage > batteryType?.cellStorageVoltage ?? 0.0 + tol {
            return BatteryStatus.charged;
        }
        if cellVoltage > batteryType?.cellStorageVoltage ?? 0.0 - tol {
            return BatteryStatus.storage;
        }
        if cellVoltage > batteryType?.cellMinVoltage ?? 0.0 {
            return BatteryStatus.low;
        }
        return BatteryStatus.danger;
    }
}
