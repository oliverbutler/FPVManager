//
//  DashboardView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 10/05/2021.
//

import SwiftUI

struct DashboardView: View {
    
    var chargedBatteries: Array<Battery>;
    var storageBatteries: Array<Battery>;
    var emptyBatteries: Array<Battery>;
    
    var body: some View {
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
}
