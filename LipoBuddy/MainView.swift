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
    private var allBatteries: FetchedResults<Battery>
    
    private var chargedBatteries: Array<Battery> {
        allBatteries.filter { $0.cellVoltage > $0.batteryType!.cellStorageVoltage + 0.1 }
    }
    
    private var storageBatteries: Array<Battery> {
        allBatteries.filter {
            $0.cellVoltage >= $0.batteryType!.cellStorageVoltage - 0.1 &&
                $0.cellVoltage <= $0.batteryType!.cellStorageVoltage + 0.1
        }
    }
    
    private var emptyBatteries: Array<Battery> {
        allBatteries.filter {
            $0.cellVoltage < $0.batteryType!.cellStorageVoltage
        }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    HStack {
                        NavigationLink(
                            destination: BatteriesViewManual(batteries: chargedBatteries, title: "Charged Batteries"),
                            label: {
                                Text(" \(chargedBatteries.count) Charged").padding(10).foregroundColor(Color.white).background(Color.green).cornerRadius(10).font(.headline)
                            })
                        NavigationLink(
                            destination: BatteriesViewManual(batteries: storageBatteries, title: "Storage Batteries"),
                            label: {
                                Text(" \(storageBatteries.count) Storage").padding(10).foregroundColor(Color.white).background(Color.yellow).cornerRadius(10).font(.headline)
                            })
                        NavigationLink(
                            destination: BatteriesViewManual(batteries: emptyBatteries, title: "Empty Batteries"),
                            label: {
                                Text(" \(emptyBatteries.count) Empty").padding(10).foregroundColor(Color.white).background(Color.red).cornerRadius(10).font(.headline)
                            })
                        
                        
                    }.padding(.top, 5.0)
                    Spacer()
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
            .tabItem {
                Label("Overview", systemImage: "house")
            }
            NavigationView {
                BatteriesView()
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
        .onAppear {
//           let predicate = NSPredicate(format: "number = %@", "1")
//            batteries.predicate
//            test()
        }
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

