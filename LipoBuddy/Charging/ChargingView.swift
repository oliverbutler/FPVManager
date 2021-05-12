//
//  ChargingView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 10/05/2021.
//

import SwiftUI

struct ChargingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedBatteries = Set<Battery>();
    
    var batteries: FetchedResults<Battery>
    
    
    
    /**
     Upon choosing a battery, only similar batteries will be shown (to avoid charging issues)
     */
    func sortBatteries() -> Array<Battery> {
        var sorted = batteries.sorted { $0.voltage < $1.voltage }
        
        sorted = sorted.filter { $0.cellVoltage < $0.batteryType!.cellMaxVoltage - 0.01 }
        
        if(selectedBatteries.count > 0) {
            let matchBattery = selectedBatteries.first
            sorted = sorted.filter {
                    $0.batteryType == matchBattery?.batteryType &&
                    $0.cellCount == matchBattery?.cellCount &&
                    $0.cellVoltage > matchBattery!.cellVoltage - 0.1 &&
                    $0.cellVoltage < matchBattery!.cellVoltage + 0.1
            }
        }
        return sorted
    }
    
    /**
     Mark all batteries as charged (by adding charge events)
     */
    func chargeAllBatteries(storage: Bool) {
        for battery in Array(selectedBatteries) {
            addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: storage ? battery.batteryType!.cellStorageVoltage : battery.batteryType!.cellMaxVoltage) }
        selectedBatteries = Set<Battery>();
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text(String(selectedBatteries.count) + " x Packs @")
                Text(String(format: "%.1fA", getChargeVoltage(cRating: 1, batteries: Array(selectedBatteries))))
                Spacer()
                Button("Set " + String(format: "%.1fV", selectedBatteries.first?.batteryType?.cellMaxVoltage ?? "")) {
                    chargeAllBatteries(storage: false)
                }
                .disabled(selectedBatteries.count < 1)
                Button("Set " + String(format: "%.1fV", selectedBatteries.first?.batteryType?.cellStorageVoltage ?? "")) {
                    chargeAllBatteries(storage: true)
                }
                .disabled(selectedBatteries.count < 1 || ((selectedBatteries.first != nil) && (selectedBatteries.first!.cellVoltage > selectedBatteries.first!.batteryType!.cellStorageVoltage - 0.01)))
            }
            .padding(25)
            if sortBatteries().count == 0 {
                Spacer()
                Text("No Chargable Batteries!")
                Spacer()
            } else {
                List(sortBatteries(), id: \.self, selection: $selectedBatteries) { b in
                    BatteryRowView(batt: b)
                }
                .environment(\.editMode, .constant(EditMode.active))
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Charging ⚡️")
    }
}
