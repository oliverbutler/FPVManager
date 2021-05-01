//
//  BatteryUpdateVoltageView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

struct BatteryUpdateVoltageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var battery: Battery;
    
    @State var batteryVoltage: String = ""
    @State var batteryCellVoltage: String = ""
    
    init(battery: Battery) {
        self.battery = battery;
        self._batteryVoltage = State(initialValue: String(battery.voltage));
        self._batteryCellVoltage = State(initialValue: String(battery.cellVoltage));
    }
    
    var body: some View {
        Form {
            Section(header: Text("PACK VOLTAGE")) {
                FloatingTextField(title: "Voltage", text: $batteryVoltage, type: "dec", units: "V")
                Button("Save changes") {
                    if(Float(batteryVoltage) != nil) {
                        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: Float(batteryVoltage)! / Float(battery.cellCount))
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
            Section(header: Text("CELL VOLTAGE")) {
                FloatingTextField(title: "Voltage", text: $batteryCellVoltage, type: "dec", units: "V")
                Button("Save changes") {
//                    battery.cellVoltage = Float(batteryCellVoltage) ?? battery.cellVoltage;
                    
                    if(Float(batteryCellVoltage) != nil) {
                        addBatteryEvent(viewContext: viewContext, batt: battery, newCellVoltage: Float(batteryCellVoltage)!)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
        }
        .navigationTitle("Update Voltage")
    }
}

struct BatteryUpdateVoltageView_Previews: PreviewProvider {
    static var previews: some View {
        
        let batt = getExampleBattery();
        
        BatteryUpdateVoltageView(battery: batt);
    }
}
