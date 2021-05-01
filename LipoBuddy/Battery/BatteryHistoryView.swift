//
//  BatteryHistoryView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 30/04/2021.
//

import SwiftUI

struct BatteryEventRowView: View {
    var event: BatteryEvent;
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:MM:SS"
        return formatter
    }()
    
    var body: some View {
        HStack {
//            Text(event.timestamp!, style: .date)
//            Text(event.timestamp!, style: .time).font(.caption)
            Text(event.timestamp!, formatter: formatter).font(.body)
        Spacer()
            Text(String(format: "%.2f", -(event.startCellVoltage - event.endCellVoltage))).foregroundColor((event.startCellVoltage - event.endCellVoltage) < 0 ? .green : .red)
            VStack {
                Text(String(format: "%.2f", event.endCellVoltage) + "V")
                Text(String(format: "%.2f", event.startCellVoltage) + "V")
            }
        }
    }
}

struct BatteryHistoryView: View {
    var battery: Battery
    
    var body: some View {
            List {
                ForEach((battery.batteryEvents?.allObjects as! [BatteryEvent]).sorted(by: { $0.timestamp! > $1.timestamp! }), id: \.self) { event  in
                    BatteryEventRowView(event: event);
                }
            }
            .navigationTitle("Battery History")
    }
}

struct BatteryHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let battery = getExampleBattery();

        BatteryHistoryView(battery: battery)
    }
}
