//
//  BatteryIconView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 01/05/2021.
//

import SwiftUI

struct BatteryIconView: View {
    
    @ObservedObject var battery: Battery
    
    var body: some View {
        switch(battery.status) {
        case BatteryStatus.charged:
            Image(systemName: "battery.100").foregroundColor(.green)
        case BatteryStatus.storage:
            Image(systemName: "battery.25").foregroundColor(.yellow)
        case BatteryStatus.low:
            Image(systemName: "battery.0").foregroundColor(.yellow)
        case BatteryStatus.danger:
            Image(systemName: "battery.0").foregroundColor(.red)
        }
    }
}

struct BatteryIconView_Previews: PreviewProvider {
    static var previews: some View {
        
        let battery = getExampleBattery();
        
        BatteryIconView(battery: battery)
    }
}
