//
//  BatteriesView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

struct StaticTextField: View {
    var title: String;
    var value: String;
    
    var body: some View {
        HStack {
            Text(title);
            Spacer();
            Text(value);
        }
    }
}

struct BatteriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Battery.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Battery.cellVoltage, ascending: false)
    ])
    private var batteries: FetchedResults<Battery>
    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            PersistenceController.shared.save();
        }
    }
    
    var body: some View {
        List {
            ForEach(batteries, id: \.self) { b in
                NavigationLink(destination: BatteryView(battery: b)) {
                    BatteryRowView(batt: b)
                }
            }.onDelete(perform: deleteBattery)
        }
        .navigationTitle("Batteries")
        .toolbar {
            NavigationLink(destination: NewBatteryView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct BatteriesViewManual: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var batteries: Array<Battery>
    var title: String
    
    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            PersistenceController.shared.save();
        }
    }
    
    var body: some View {
        List {
            ForEach(batteries, id: \.self) { b in
                NavigationLink(destination: BatteryView(battery: b)) {
                    BatteryRowView(batt: b)
                }
            }.onDelete(perform: deleteBattery)
        }
        .navigationTitle(title)
        .toolbar {
            NavigationLink(destination: NewBatteryView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}
