//
//  LipoBuddyApp.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI
import CoreData

func initCoreData() {
    
    let viewContext = PersistenceController.shared.container.viewContext;

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BatteryType")
    
    var hasLipo = false;
    var hasLihv = false;
    var hasLion = false;
    
    func makeLipo(type: BatteryType) {
        type.name = "LiPo"
        type.cellMinVoltage = 3.3
        type.cellMaxVoltage = 4.2
        type.cellStorageVoltage = 3.8
    }
    
    func makeLihv(type: BatteryType) {
        type.name = "LiHV"
        type.cellMinVoltage = 3.3
        type.cellMaxVoltage = 4.35
        type.cellStorageVoltage = 3.8
    }
    
    func makelion(type: BatteryType) {
        type.name = "Li-Ion"
        type.cellMinVoltage = 3.4
        type.cellMaxVoltage = 4.2
        type.cellStorageVoltage = 3.8
    }
    
    do {
        let batteryTypes = try viewContext.fetch(fetchRequest)

        // Update any existing batteries
        for batteryType in batteryTypes as! [BatteryType] {
//            print(batteryType.name ?? "?")
            switch batteryType.name {
            case "LiPo":
                if(hasLipo) { viewContext.delete(batteryType); }
                hasLipo = true;
                makeLipo(type: batteryType)
            case "LiHV":
                if(hasLihv) { viewContext.delete(batteryType); }
                hasLihv = true;
                makeLihv(type: batteryType)
            case "Li-Ion":
                if(hasLion) { viewContext.delete(batteryType); }
                hasLion = true;
                makelion(type: batteryType)
            default:
                viewContext.delete(batteryType)
            }
        }
    } catch {
        print(error)
    }
    
    if(!hasLipo) {
        let liPo = BatteryType(context: viewContext)
        makeLipo(type: liPo);
    }
    
    if(!hasLihv) {
        let liHV = BatteryType(context: viewContext)
        makeLihv(type: liHV)
    }
    
    if(!hasLion) {
        let lion = BatteryType(context: viewContext)
        makelion(type: lion)
    }
    
    PersistenceController.shared.save();
}


@main
struct LipoBuddyApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    func onAppLoad() {
        initCoreData()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext )
                .onAppear(perform: onAppLoad)
        }
    }
}
