//
//  BatteryRowView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

/**
    Row which is displayed to represent a single battery shows "charged" value based upon the limits of a specific batteries type.
 */
struct BatteryRowView: View {
    @ObservedObject var batt: Battery
    
    init(batt: Battery) {
        self.batt = batt;
    }
    
    var body: some View {
        HStack {
            BatteryIconView(battery: batt)
            VStack {
                Text(String( format: "%.2fV", batt.cellVoltage))
                Text(String(format: "%.2fV", batt.voltage))
            }.padding(.trailing, 25)
            
            Text(String(batt.name))
            Spacer()
            Text(String(batt.capacity) + "mAh")
            Text(String(batt.cellCount) + "S")
        }
    }
}


struct BatteryRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        let batt = getExampleBattery();
        
        BatteryRowView(batt: batt);
    }
}
