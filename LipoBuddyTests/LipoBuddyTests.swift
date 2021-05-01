//
//  LipoBuddyTests.swift
//  LipoBuddyTests
//
//  Created by Oliver Butler on 30/04/2021.
//

import XCTest
@testable import LipoBuddy;

class LipoBuddyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testCreateBattery() throws {
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let time = Date();
        
        let battery: Battery = Battery(context: viewContext);
        battery.name = "0"
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = time;
        battery.cycleCount = 0
        battery.notes = "test123"
        battery.cellVoltage = 4.2
        
        XCTAssertEqual(battery.name, "0");
        XCTAssertEqual(battery.cellCount, 4);
        XCTAssertEqual(battery.capacity, 100);
        XCTAssertEqual(battery.createdTimestamp, time);
        XCTAssertEqual(battery.cycleCount, 0.0);
        XCTAssertEqual(battery.notes, "test123");
        XCTAssertEqual(battery.cellVoltage, 4.2);
    }
    
    func testGetExampleBattery() throws {
        let battery = getExampleBattery();
        
        XCTAssertEqual(battery.name, "B1");
    }
    
    func testBatteryStatus() throws {
        let battery = getExampleBattery();
        
        battery.cellVoltage = 3.9
        XCTAssertEqual(battery.status, BatteryStatus.charged)
        
        battery.cellVoltage = 3.89
        XCTAssertEqual(battery.status, BatteryStatus.storage)
        
        battery.cellVoltage = 3.8
        XCTAssertEqual(battery.status, BatteryStatus.storage)
        
        battery.cellVoltage = 3.79
        XCTAssertEqual(battery.status, BatteryStatus.storage)
        
        battery.cellVoltage = 3.4
        XCTAssertEqual(battery.status, BatteryStatus.low)
        
        battery.cellVoltage = 3.2
        XCTAssertEqual(battery.status, BatteryStatus.danger)
    }
    
    func testCustomBatteryProperties() throws {
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let time = Date();
        
        let battery: Battery = Battery(context: viewContext);
        battery.name = "0"
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = time;
        battery.cycleCount = 0
        battery.notes = "test123"
        battery.cellVoltage = 4.2
        
        XCTAssertEqual(battery.voltage, 16.8);
        XCTAssertEqual(battery.cellVoltage, 4.2);
        
        battery.voltage = 16.0;
        
        XCTAssertEqual(battery.voltage, 16.0)
        XCTAssertEqual(battery.cellVoltage, 4.0)
        
        
    }

    func testGetCycles() throws {
        
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let battery: Battery = Battery(context: viewContext);
        battery.name = "0"
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = Date()
        battery.cycleCount = 0
        battery.notes = ""
        battery.cellVoltage = 4.2
        
        let batteryType: BatteryType = BatteryType(context: viewContext);
        batteryType.cellStorageVoltage = 3.8;
        batteryType.cellMaxVoltage = 4.2;
        batteryType.cellMinVoltage = 3.3;
        
        battery.batteryType = batteryType;
        
        // 4.2 -> 3.8 (half-ish)
        XCTAssertEqual(getCycles(batt: battery, newCellVoltage: 3.8), 0.44444, accuracy: 0.001);
        
        // 4.2 -> 3.3 (Full cycle)
        XCTAssertEqual(getCycles(batt: battery, newCellVoltage: 3.3), 1.0, accuracy: 0.001);
        
        // 4.2 -> 4.2 (No Change)
        XCTAssertEqual(getCycles(batt: battery, newCellVoltage: 4.2), 0, accuracy: 0.001);
        
        battery.cellVoltage = 3.3;
        
        // 3.3 -> 4.2 (No Change - Full Charge)
        XCTAssertEqual(getCycles(batt: battery, newCellVoltage: 4.2), 0, accuracy: 0.001);
        
    }
    
    func testNewBatteryEvent() throws {
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let battery: Battery = Battery(context: viewContext);
        battery.name = "0"
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = Date()
        battery.cycleCount = 0
        battery.notes = ""
        battery.cellVoltage = 4.2
        
        let batteryType: BatteryType = BatteryType(context: viewContext);
        batteryType.cellStorageVoltage = 3.8;
        batteryType.cellMaxVoltage = 4.2;
        batteryType.cellMinVoltage = 3.3;
        
        battery.batteryType = batteryType;
        
        // Start at 4.2V (0 cycles)
        XCTAssertEqual(battery.cycleCount, 0, accuracy: 0.001);
        XCTAssertEqual(battery.cellVoltage, 4.2, accuracy: 0.001)
        
        // Discharge to 3.8V (0.44 cycles)
        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 3.8);
        XCTAssertEqual(battery.cycleCount, 0.4444, accuracy: 0.001)
        XCTAssertEqual(battery.cellVoltage, 3.8, accuracy: 0.001)
    
        // Check that the battery event is added correctly
        let latestEvent = battery.batteryEvents!.allObjects[0] as! BatteryEvent
        XCTAssertEqual(latestEvent.startCellVoltage, 4.2, accuracy: 0.001)
        XCTAssertEqual(latestEvent.endCellVoltage, 3.8, accuracy: 0.001)
        XCTAssertEqual(latestEvent.flight, nil);
        
        // Recharge to 4.2V (0 cycles)
        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 4.2);
        XCTAssertEqual(battery.cycleCount, 0.4444, accuracy: 0.001)
        XCTAssertEqual(battery.cellVoltage, 4.2, accuracy: 0.001)
        
        // Discharge to 3.3V (1 cycles)
        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: 3.3);
        XCTAssertEqual(battery.cycleCount, 1.4444, accuracy: 0.001)
        XCTAssertEqual(battery.cellVoltage, 3.3, accuracy: 0.001)
        
    }
}
