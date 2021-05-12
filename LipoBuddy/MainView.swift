//
//  ContentView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI
import Combine

import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Battery.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Battery.cellVoltage, ascending: false)
    ])
    private var allBatteries: FetchedResults<Battery>
    
    // Find all batteries which are charged
    private var chargedBatteries: Array<Battery> {
        allBatteries.filter { $0.status == BatteryStatus.charged; }
    }
    
    // Find all storage batteries
    private var storageBatteries: Array<Battery> {
        allBatteries.filter { $0.status == BatteryStatus.storage; }
    }
    
    // Find all empty batteries (or "danger" batteries)
    private var emptyBatteries: Array<Battery> {
        allBatteries.filter {
            $0.status == BatteryStatus.low || $0.status == BatteryStatus.danger
        }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                DashboardView(chargedBatteries: chargedBatteries, storageBatteries: storageBatteries, emptyBatteries: emptyBatteries)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Overview", systemImage: "house")
            }
            
            NavigationView {
                BatteriesView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Batteries", systemImage: "battery.100")
            }
            .tag(1)
            
            NavigationView {
                ChargingView(batteries: allBatteries);
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Charging", systemImage: "battery.100.bolt")
            }
            .tag(2)
        }
        .accentColor(ColourManager.appAccent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

