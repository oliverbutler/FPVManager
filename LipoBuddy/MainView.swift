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
    @FetchRequest(entity: Battery.entity(), sortDescriptors: [])
    private var batteries: FetchedResults<Battery>
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Number Batteries: \(batteries.count)" )
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .tabItem {
                Label("Overview", systemImage: "house")
            }
            NavigationView {
                BatteriesView()
                .navigationTitle("Batteries")
                .toolbar {
                    NavigationLink(destination: NewBatteryView()) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .tabItem {
                Label("Batteries", systemImage: "battery.100.bolt")
            }
            .tag(1)
            
            Text("First View")
            .tabItem {
                Label("Flying", systemImage: "airplane")
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
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

