//
//  ContentView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI
import Combine

import CoreData

struct BatteryRow: View {
    var batt: Battery
    var cellVoltage: Float
    
    init(batt: Battery) {
        self.batt = batt;
        self.cellVoltage = self.batt.voltage / Float(self.batt.cellCount);
    }
    
    var body: some View {
        HStack {
            Text(String(batt.number))
            if cellVoltage > 3.7 && cellVoltage < 3.9 {
                Image(systemName: "battery.25").foregroundColor(.yellow)
            } else if cellVoltage > 3.85 {
                Image(systemName: "battery.100").foregroundColor(.green)
            } else {
                Image(systemName: "battery.0").foregroundColor(.red)
            }
            
            Text(String(format: "%.2fV", cellVoltage))
            Spacer()
            Text(String(format: "%.2fV", batt.voltage))
            Text(String(batt.capacity) + "mAh")
            Text(String(batt.cellCount) + "S")
        }
    }
}

struct ColourManager {
    static let appBlack = Color("Black")
    static let appAccent = Color("Accent")
}

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    let type: String
    let units: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color(.placeholderText))
                    .opacity(text.wrappedValue.isEmpty ? 0 : 1)
                    .offset(y: text.wrappedValue.isEmpty ? 20 : 0)
                if type == "dec" {
                    TextField(title, text: text)
                    .keyboardType(.decimalPad)
                } else if type == "int" {
                    TextField(title, text: text)
                    .keyboardType(.numberPad)
                } else if type == "string" {
                    TextField(title, text: text)
                }
            }
            Text(units)
                .foregroundColor(Color(.placeholderText))
        }.animation(.default)
    }
}

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

struct NewBatteryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var batteryId: String = ""
    @State var batteryCapacity: String = ""
    @State var batteryCellCount: String = ""
    @State var batteryVoltage: String = ""
    
    @State private var typeIndex = 0
    var type = ["LiPo", "LiHV", "Li-ion"]
    
    var body: some View {
        Form {
            Section(header: Text("BATTERY")) {
                FloatingTextField(title: "Battery ID", text: $batteryId, type: "int", units: "")
                FloatingTextField(title: "Capacity", text: $batteryCapacity, type: "int", units: "MaH")
                FloatingTextField(title: "Cell Count", text: $batteryCellCount, type: "int", units: "")
                FloatingTextField(title: "Voltage", text: $batteryVoltage, type: "dec", units: "V")
            }
            Section(header: Text("TYPE")) {
                Picker(selection: $typeIndex, label: Text("Show Types")) {
                        ForEach(0 ..< type.count) {
                            Text(self.type[$0])
                        }
                    }
                
            }
            Section {
                Button(action: {
                    addBattery(number: batteryId, cellCount: batteryCellCount, capacity: batteryCapacity, voltage: batteryVoltage)
                }) {
                    Text("Create new Battery")
                }
                .disabled(batteryId == "" || batteryVoltage == "" || batteryCapacity == "" || batteryCellCount == "")
            }
        }
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
            
            saveContext()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func
    saveContext() {
            do {
        try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}

struct BatteryView: View {
    
    var battery: Battery;
    
    @State var batteryId: String = ""
    @State var batteryCapacity: String = ""
    @State var batteryCellCount: String = ""
    @State var batteryVoltage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Battery " + String(battery.number))
            Form {
                FloatingTextField(title: "Battery ID", text: $batteryId, type: "int", units: "")
                FloatingTextField(title: "Capacity", text: $batteryCapacity, type: "int", units: "MaH")
                FloatingTextField(title: "Cell Count", text: $batteryCellCount, type: "int", units: "")
                FloatingTextField(title: "Voltage", text: $batteryVoltage, type: "dec", units: "V")
            }
        }
    }
}

struct BatteriesView: View {
    
    var batteries: FetchedResults<Battery>;
    var deleteBattery: (_ offsets: IndexSet) -> Void;
    
    var body: some View {
        List {
            ForEach(batteries) { b in
                NavigationLink(destination: BatteryView(battery: b)) {
                    BatteryRow(batt: b)
                }
            }.onDelete(perform: deleteBattery)
            .onTapGesture(perform: {
                
            })

        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Battery.entity(), sortDescriptors: [])
    private var batteries: FetchedResults<Battery>
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Number Batteries: \(batteries.count)" )
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .tabItem {
                Label("Overview", systemImage: "house")
            }
            NavigationView {
                BatteriesView(batteries: batteries, deleteBattery: deleteBattery)
                .navigationTitle("Batteries")
                .toolbar {
                    NavigationLink(destination: NewBatteryView()) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .tabItem {
                Label("Batteries", systemImage: "battery.100.bolt")
            }
            .tag(1)
            
            Text("First View")
            .tabItem {
                Label("Flying", systemImage: "airplane")
            }
            .tag(2)
        }
        .accentColor(ColourManager.appAccent)
    }
    
    private func
    saveContext() {
            do {
        try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }

    
    private func deleteBattery(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                batteries[$0]
            }.forEach(viewContext.delete)
            
            saveContext()
        }
    }

    
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
#endif

