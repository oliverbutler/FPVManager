//
//  BatteriesView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

/**
    Row which is displayed to represent a single battery shows "charged" value based upon the limits of a specific batteries type.
 */
struct BatteryRow: View {
    @ObservedObject var batt: Battery
    
    init(batt: Battery) {
        self.batt = batt;
    }
    
    var body: some View {
        HStack {
            Text(String(batt.number))
            if batt.cellVoltage > 3.7 && batt.cellVoltage < 3.9 {
                Image(systemName: "battery.25").foregroundColor(.yellow)
            } else if batt.cellVoltage > 3.85 {
                Image(systemName: "battery.100").foregroundColor(.green)
            } else {
                Image(systemName: "battery.0").foregroundColor(.red)
            }
            Text(String( format: "%.2fV", batt.cellVoltage))
            Spacer()
            Text(String(format: "%.2fV", batt.voltage))
            Text(String(batt.capacity) + "mAh")
            Text(String(batt.cellCount) + "S")
        }
    }
}

/**
    View to create a new Battery
 */
struct NewBatteryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                FloatingTextField(title: "Battery ID", text: $batteryId, type: "int", units: "")
                FloatingTextField(title: "Capacity", text: $batteryCapacity, type: "int", units: "MaH")
//                FloatingTextField(title: "Cell Count", text: $batteryCellCount, type: "int", units: "")
                FloatingTextField(title: "Voltage", text: $batteryVoltage, type: "dec", units: "V")
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
                    addBattery(number: batteryId, cellCount: String(batteryCellCount), capacity: batteryCapacity, voltage: batteryVoltage)
                }) {
                    Text("Create new Battery")
                }
                .disabled(batteryId == "" || batteryVoltage == "" || batteryCapacity == "" || selectedBatteryType == nil)
            }
        }
        .navigationTitle("New Battery")
    }
    
    private func addBattery(number: String, cellCount: String, capacity: String, voltage: String) {
        
        withAnimation {
            let newBattery = Battery(context: viewContext)
            newBattery.number = Int64(number) ?? 0
            newBattery.cellCount = Int64(cellCount) ?? 0
            newBattery.capacity = Int64(capacity) ?? 0
            newBattery.createdTimestamp = Date()
            newBattery.cycleCount = 0
            newBattery.notes = ""
            newBattery.voltage = Float(voltage) ?? 0
            
            newBattery.batteryType = selectedBatteryType
            
            PersistenceController.shared.save();
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct StaticTextField: View {
    var title: String;
    var value: String;
    
    var body: some View {
        HStack {
            Text(title);
            Spacer();
            Text(value);
        }
    }
}

struct BatteryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var battery: Battery
    
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
                    
                    StaticTextField(title: "ID", value: String(battery.number))
                    StaticTextField(title: "Capacity", value: String(battery.capacity) + "mAh")
                    StaticTextField(title: "Type", value: String(battery.batteryType?.name ?? "Unknown"))
                    StaticTextField(title: "Cell Count", value: String(battery.cellCount) + "S")
                    StaticTextField(title: "Pack Voltage", value: String(format: "%.02f", battery.voltage) + "V")
                    StaticTextField(title: "Cell Voltage", value: String(format: "%.02f", battery.voltage / Float(battery.cellCount)) + "V")
                    
                }
                Section(header: Text("ACTIONS")) {
                    NavigationLink(destination: BatteryUpdateVoltageView(battery: battery)) {
                        Text("Set Batt Voltage")
                    }
                    NavigationLink(destination: InputFlightView()) {
                        Text("Input Flight")
                    }
                }
                Section(header: Text("HISTORY")) {
                    StaticTextField(title: "Cycle Count", value: String(battery.cycleCount))
                    HStack {
                        Text("Added")
                        Spacer();
                        Text(battery.createdTimestamp ?? Date(), style: .date)
                    }
                }
            }
        }
        .navigationTitle("Battery " + String(battery.number))
    }
}

struct BatteryUpdateVoltageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var battery: Battery;
    
    @State var batteryVoltage: String = ""
    @State var batteryCellVoltage: String = ""
    
    init(battery: Battery) {
        self.battery = battery;
        self._batteryVoltage = State(initialValue: String(battery.voltage));
        self._batteryCellVoltage = State(initialValue: String(battery.voltage / Float(battery.cellCount)));
    }
    
    var body: some View {
        Form {
            Section(header: Text("PACK VOLTAGE")) {
                FloatingTextField(title: "Voltage", text: $batteryVoltage, type: "int", units: "V")
                Button("Save changes") {
                    battery.voltage = Float(batteryVoltage) ?? battery.voltage;
                    
                    PersistenceController.shared.save();
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
            Section(header: Text("CELL VOLTAGE")) {
                FloatingTextField(title: "Voltage", text: $batteryCellVoltage, type: "int", units: "V")
                Button("Save changes") {
                    let newCellVoltage = Float(batteryCellVoltage) ?? battery.voltage / Float(battery.cellCount)
                    battery.voltage = newCellVoltage * Float(battery.cellCount)
                    
                    PersistenceController.shared.save();
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
        }
        .navigationTitle("Update Voltage")
    }
}

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


struct BatteriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Battery.entity(), sortDescriptors: [])
    private var batteries: FetchedResults<Battery>
    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            PersistenceController.shared.save();
        }
    }
    
    var body: some View {
        List {
            ForEach(batteries, id: \.self) { b in
                NavigationLink(destination: BatteryView(battery: b)) {
                    BatteryRow(batt: b)
                }
            }.onDelete(perform: deleteBattery)
        }
        .navigationTitle("Batteries")
        .toolbar {
            NavigationLink(destination: NewBatteryView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct BatteriesViewManual: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var batteries: Array<Battery>
    var title: String
    
    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            PersistenceController.shared.save();
        }
    }
    
    var body: some View {
        List {
            ForEach(batteries, id: \.self) { b in
                NavigationLink(destination: BatteryView(battery: b)) {
                    BatteryRow(batt: b)
                }
            }.onDelete(perform: deleteBattery)
        }
        .navigationTitle(title)
        .toolbar {
            NavigationLink(destination: NewBatteryView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}
