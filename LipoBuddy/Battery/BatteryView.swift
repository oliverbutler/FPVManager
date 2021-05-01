//
//  BatteryView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

struct BatteryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var battery: Battery
    
    @State private var showDelete = false
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Spacer()
                    Image("auline_500")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                    Spacer()
                }
                Section(header: Text("BATTERY")) {
                    
                    StaticTextField(title: "ID", value: String(battery.name))
                    StaticTextField(title: "Capacity", value: String(battery.capacity) + "mAh")
                    StaticTextField(title: "Type", value: String(battery.batteryType?.name ?? "Unknown"))
                    StaticTextField(title: "Cell Count", value: String(battery.cellCount) + "S")
                    StaticTextField(title: "Pack Voltage", value: String(format: "%.02f", battery.voltage) + "V")
                    StaticTextField(title: "Cell Voltage", value: String(format: "%.02f", battery.cellVoltage) + "V")
                    
                }
                Section(header: Text("ACTIONS")) {
                    NavigationLink(destination: BatteryUpdateVoltageView(battery: battery)) {
                        Text("Set Batt Voltage")
                    }
                    Button("Set Charged (\(String(format: "%.02f", battery.batteryType!.cellMaxVoltage))V)") {
                        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: battery.batteryType!.cellMaxVoltage)
                    }.disabled(battery.cellVoltage == battery.batteryType!.cellMaxVoltage)
                    Button("Set Storage (\(String(format: "%.02f", battery.batteryType!.cellStorageVoltage))V)") {
                        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: battery.batteryType!.cellStorageVoltage)
                    }.disabled(battery.cellVoltage == battery.batteryType!.cellStorageVoltage)
                    NavigationLink(destination: InputFlightView()) {
                        Text("Input Flight")
                    }
                }
                Section(header: Text("HISTORY")) {
                    StaticTextField(title: "Cycles", value: String(format: "%.1f",battery.cycleCount))
                    NavigationLink(destination: BatteryHistoryView(battery: battery)) {
                        Text("View History")
                    }
                }
                Section(header: Text("SETTINGS")) {
                    NavigationLink(destination: BatteryUpdateView(battery: battery)) {
                        Text("Update Details")
                    }
                    HStack {
                        Text("Battery Added")
                        Spacer();
                        Text(battery.createdTimestamp ?? Date(), style: .date)
                    }
                    Button("Delete Battery") {
                        showDelete = true
                    }
                }
            }
        }
        .alert(isPresented:$showDelete) {
            Alert(
                title: Text("Delete Battery"),
                message: Text("Are you sure you want to delete?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewContext.delete(battery);
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle(battery.name)
    }
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let battery = getExampleBattery();
        BatteryView(battery: battery)
    }
}
