//
//  BatteryUpdate.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 01/05/2021.
//

import SwiftUI

struct BatteryUpdateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var battery: Battery;
    
    @State var batteryName: String = ""
    
    init(battery: Battery) {
        self.battery = battery;
        self._batteryName = State(initialValue: battery.name);
    }
    
    var body: some View {
        Form {
            Section(header: Text("BATTERY NAME")) {
                FloatingTextField(title: "Name", text: $batteryName, type: "string", units: "")
                Button("Save changes") {
                    battery.name = batteryName;
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
        }
        .navigationTitle("Update Battery")
    }
}

struct BatteryUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        
        let batt = getExampleBattery();
        
        BatteryUpdateVoltageView(battery: batt);
    }
}
