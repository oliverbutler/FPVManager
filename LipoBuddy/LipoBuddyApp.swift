//
//  LipoBuddyApp.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI
import CoreData

func InitCoreData() {
    
    let viewContext = PersistenceController.shared.container.viewContext;
    
    // Create Fetch Request
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BatteryType")

    // Create Batch Delete Request
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try viewContext.execute(batchDeleteRequest)
    } catch {
        // Error Handling
    }
    
    
    let liPo = BatteryType(context: viewContext)
    liPo.name = "LiPo"
    liPo.cellMinVoltage = 3.3
    liPo.cellMaxVoltage = 4.2
    liPo.cellStorageVoltage = 3.8
    
    let liHV = BatteryType(context: viewContext)
    liHV.name = "LiHV"
    liHV.cellMinVoltage = 3.3
    liHV.cellMaxVoltage = 4.35
    liHV.cellStorageVoltage = 3.8
    
    let lion = BatteryType(context: viewContext)
    lion.name = "Li-Ion"
    lion.cellMinVoltage = 3.4
    lion.cellStorageVoltage = 3.8
    lion.cellMaxVoltage = 4.2
    
    PersistenceController.shared.save();
}


@main
struct LipoBuddyApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    func onAppLoad() {
//        let hasLaunchedKey = "HasLaunched"
//        let defaults = UserDefaults.standard
//        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
//
//        if !hasLaunched {
        InitCoreData()
//            defaults.set(true, forKey: hasLaunchedKey)
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext )
                .onAppear(perform: onAppLoad)
        }
    }
}
