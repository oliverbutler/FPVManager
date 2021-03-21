//
//  ContentView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI

import CoreData

struct BatteryRow: View {
    var batt: Battery
    
    var body: some View {
        HStack {
            Text("Battery " + String(batt.number))
            Spacer()
            Text(String(format: "%.1f", batt.voltage))
            Text(String(batt.cellCount))
        }
    }
}

struct ColourManager {
    static let appBlack = Color("Black")
    static let appAccent = Color("Accent")
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var batteries: FetchedResults<Battery>
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Number Batteries: \(batteries.count)")
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    Button(action: {
                        print("Tapped!")
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            NavigationView {
                List {
                    ForEach(batteries) { b in
                        BatteryRow(batt: b)
                    }.onDelete(perform: deleteBattery)
    
                }
                .navigationTitle("Batteries")
                .toolbar {
                    Button("Add Battery") {
                        addBattery()
                    }
                }
            }
            .tabItem {
                Label("Charging", systemImage: "battery.100.bolt")
            }
            .tag(1)
            
            Text("First View")
            .tabItem {
                Label("Flying", systemImage: "airplane")
            }
            .tag(2)
            
            Text("Second View")
            .tabItem {
                Label("Storage", systemImage: "battery.25")
            }
            .tag(3)
        }
        .accentColor(ColourManager.appAccent)
    }
    
    private func
    saveContext() {
            do {
        try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }

    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            saveContext()
        }
    }
    
    private func addBattery() {
        
        withAnimation {
            let newBattery = Battery(context: viewContext)
            newBattery.number = 1
            newBattery.cellCount = 4
            newBattery.capacity = 1300
            newBattery.createdTimestamp = Date()
            newBattery.cycleCount = 0
            newBattery.notes = ""
            newBattery.voltage = 3.80
            
            saveContext()
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}

