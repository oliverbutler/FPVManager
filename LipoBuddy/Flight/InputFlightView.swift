//
//  InputFlightView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

struct InputFlightView: View {
    
    @State private var batteryVoltage: String = ""
    @State private var batteryUndervolt: Bool = false
    @State private var batteryApparentCurrentDrawn: String = ""
    @State private var batteryCurrentDrawn: String = ""
    
    @State private var flightTime: String = ""
    
    @State private var typeIndex = 0
    var aircraft = ["Marmotte", "Mini", "Chameleon"]
    
    var body: some View {
        Form {
            Section(header: Text("BATTERY")) {
                FloatingTextField(title: "Final Voltage", text: $batteryVoltage, type: "dec", units: "V")
                FloatingTextField(title: "Apparent Current Drawn", text: $batteryApparentCurrentDrawn, type: "int", units: "mAh")
                FloatingTextField(title: "Actual Current Drawn", text: $batteryCurrentDrawn, type: "int", units: "mAh")
                Toggle(isOn: $batteryUndervolt) {
                    Text("Undervolted")
                }
            }
            Section(header: Text("FLIGHT")) {
                Picker(selection: $typeIndex, label: Text("Aircraft")) {
                    ForEach(0 ..< aircraft.count) {
                        Text(self.aircraft[$0])
                    }
                }
                FloatingTextField(title: "Flight Time", text: $flightTime, type: "string", units: "min:sec")
            }
            Section {
                Button("Submit Flight") {
                    
                }
            }
        }.navigationTitle("New Flight")
    }
}

struct InputFlightView_Previews: PreviewProvider {
    static var previews: some View {
        InputFlightView()
    }
}
