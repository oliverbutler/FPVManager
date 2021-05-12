//
//  NewBatteryView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

/**
    View to create a new Battery
 */
struct NewBatteryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: BatteryType.entity(), sortDescriptors: [])
    var batteryTypes: FetchedResults<BatteryType>
    
    @State var batteryId: String = ""
    @State var batteryCapacity: String = ""
    @State var batteryCellCount = 4;
    @State var batteryVoltage: String = ""
    
    @State var selectedBatteryType: BatteryType? = nil;
    
    var body: some View {
        Form {
            Section(header: Text("BATTERY")) {
                FloatingTextField(title: "Battery ID", text: $batteryId, type: "string", units: "")
                FloatingTextField(title: "Capacity", text: $batteryCapacity, type: "int", units: "MaH")
                FloatingTextField(title: "Pack Voltage", text: $batteryVoltage, type: "dec", units: "V")
                StepperView(value: batteryCellCount);
            }
            
            Section(header: Text("TYPE")) {
                Picker(selection: $selectedBatteryType, label: Text("Show Types")) {
                    ForEach(batteryTypes, id: \.self) { bt in
                        Text(bt.name ?? "Unknown").tag(bt as BatteryType?)
                    }
                }
                
            }
            Section {
                Button(action: {
                    addBattery(name: batteryId, cellCount: String(batteryCellCount), capacity: batteryCapacity, voltage: batteryVoltage)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create new Battery")
                }
                .disabled(batteryId == "" || batteryVoltage == "" || batteryCapacity == "" || selectedBatteryType == nil)
            }
        }
        .navigationTitle("New Battery")
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func addBattery(name: String, cellCount: String, capacity: String, voltage: String) {
        withAnimation {
            let newBattery = Battery(context: viewContext)
            newBattery.name = name
            newBattery.cellCount = Int64(cellCount) ?? 0
            newBattery.capacity = Int64(capacity) ?? 0
            newBattery.createdTimestamp = Date()
            newBattery.cycleCount = 0
            newBattery.notes = ""
            newBattery.voltage = Float(voltage) ?? 0
            
            newBattery.batteryType = selectedBatteryType
            
            PersistenceController.shared.save();
            
        }
    }
}

struct NewBatteryView_Previews: PreviewProvider {
    static var previews: some View {
        NewBatteryView()
    }
}
