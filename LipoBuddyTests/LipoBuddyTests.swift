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
        battery.number = 0
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = time;
        battery.cycleCount = 0
        battery.notes = "test123"
        battery.voltage = 16.8
        
        XCTAssertEqual(battery.number, 0);
        XCTAssertEqual(battery.cellCount, 4);
        XCTAssertEqual(battery.capacity, 100);
        XCTAssertEqual(battery.createdTimestamp, time);
        XCTAssertEqual(battery.cycleCount, 0.0);
        XCTAssertEqual(battery.notes, "test123");
        XCTAssertEqual(battery.voltage, 16.8);
        XCTAssertEqual(battery.cellVoltage, 16.8/4);
    }

    func testGetCycles() throws {
        
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let battery: Battery = Battery(context: viewContext);
        battery.number = 0
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = Date()
        battery.cycleCount = 0
        battery.notes = ""
        battery.voltage = 16.8
        
        let batteryType: BatteryType = BatteryType(context: viewContext);
        batteryType.cellMaxVoltage = 4.2;
        batteryType.cellMinVoltage = 3.3;
        
        battery.batteryType = batteryType;
        
        // 16.8 -> 15.2 (half-ish)
        XCTAssertEqual(getCycles(batt: battery, newVoltage: 15.2), 0.44444, accuracy: 0.001);
        
        // 16.8 -> 13.2 (Full cycle)
        XCTAssertEqual(getCycles(batt: battery, newVoltage: 13.2), 1.0, accuracy: 0.001);
        
    }
    
    func testNewBatteryEvent() throws {
        let viewContext = PersistenceController.shared.container.viewContext;
        
        let battery: Battery = Battery(context: viewContext);
        battery.number = 0
        battery.cellCount = 4
        battery.capacity = 100
        battery.createdTimestamp = Date()
        battery.cycleCount = 0
        battery.notes = ""
        battery.voltage = 16.8
        
        let batteryType: BatteryType = BatteryType(context: viewContext);
        batteryType.cellMaxVoltage = 4.2;
        batteryType.cellMinVoltage = 3.3;
        
        battery.batteryType = batteryType;
        
        // Start at 16.8V (0 cycles)
        XCTAssertEqual(battery.cycleCount, 0, accuracy: 0.001);
        XCTAssertEqual(battery.voltage, 16.8, accuracy: 0.001)
        
        // Discharge to 15.2V (0.44 cycles)
        newBatteryEvent(batt: battery, endVoltage: 15.2);
        XCTAssertEqual(battery.cycleCount, 0.4444, accuracy: 0.001)
        XCTAssertEqual(battery.voltage, 15.2, accuracy: 0.001)
    
        // Check that the battery event is added correctly
        let latestEvent = battery.batteryEvents!.allObjects[0] as! BatteryEvent
        XCTAssertEqual(latestEvent.startVoltage, 16.8, accuracy: 0.001)
        XCTAssertEqual(latestEvent.endVoltage, 15.2, accuracy: 0.001)
        XCTAssertEqual(latestEvent.flight, nil);
        
        // Recharge to 16.8V (0 cycles)
        newBatteryEvent(batt: battery, endVoltage: 16.8);
        XCTAssertEqual(battery.cycleCount, 0.4444, accuracy: 0.001)
        XCTAssertEqual(battery.voltage, 16.8, accuracy: 0.001)
        
        // Discharge to 13.2V (1 cycles)
        newBatteryEvent(batt: battery, endVoltage: 13.2);
        XCTAssertEqual(battery.cycleCount, 1.4444, accuracy: 0.001)
        XCTAssertEqual(battery.voltage, 13.2, accuracy: 0.001)
        
    }
}
