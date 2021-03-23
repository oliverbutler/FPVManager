//
//  SettingsView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var enableNFC: Bool = true
    @State var chargingCRate: String = "1.0"
    @State var chargingMaxDiff: String = "1.0"
    
    var body: some View {
        Form {
            Section(header: Text("APP")) {
                Toggle(isOn: $enableNFC) {
                    Text("Enable NFC")
                }
            }
            Section(header: Text("CHARGING")) {
                FloatingTextField(title: "Charging Rate", text: $chargingCRate, type: "dec", units: "C")
                FloatingTextField(title: "Maximum Charging Voltage Difference", text: $chargingMaxDiff, type: "int", units: "V")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
