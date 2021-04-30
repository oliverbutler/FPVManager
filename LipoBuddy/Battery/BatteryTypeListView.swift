//
//  BatteryTypeListView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

struct BatteryTypeRow: View {
    
    @ObservedObject var bType: BatteryType
    
    var body: some View {
        HStack {
            Text(bType.name ?? "")
            Spacer()
            Text(String(format: "%.2fV", bType.cellMinVoltage))
            Text(String(format: "%.2fV", bType.cellStorageVoltage))
            Text(String(format: "%.2fV", bType.cellMaxVoltage))
        }
    }
}

struct BatteryTypeListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: BatteryType.entity(), sortDescriptors: [])
    private var batteryTypes: FetchedResults<BatteryType>

    var body: some View {
        List {
            ForEach(batteryTypes) { b in
                BatteryTypeRow(bType: b)
            }
        }
        .navigationTitle("Battery Types")
        .toolbar {
//            NavigationLink(destination: NewBatteryView()) {
//                Image(systemName: "plus.circle")
//            }
        }
    }
}

struct BatteryTypeListView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryTypeListView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
