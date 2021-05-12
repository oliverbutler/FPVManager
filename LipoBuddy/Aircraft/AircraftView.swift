//
//  AircraftView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

struct AircraftRow: View {
    
    var aircraft: Aircraft;
    
    var body: some View {
        HStack {
            Text(aircraft.name ?? "")
            Text(String(aircraft.propellerSize))
        }
    }
}

struct NewAircraftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var aircraftName: String = ""
    @State var aircraftPropellerSize: String = ""
    @State var aircraftWeight: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("AIRCRAFT")) {
                FloatingTextField(title: "Name", text: $aircraftName, type: "string", units: "")
                FloatingTextField(title: "Propeller Size", text: $aircraftPropellerSize, type: "dec", units: "inches")
                FloatingTextField(title: "Weight", text: $aircraftWeight, type: "dec", units: "g")
            }
            Section(header: Text("BATTERIES")) {
                
            }
            Section {
                Button(action: {
                    addAircraft(name: aircraftName, propellerSize: aircraftPropellerSize, weight: aircraftWeight)
                }) {
                    Text("Create new Aircraft")
                }
                .disabled(aircraftName == "" || aircraftPropellerSize == "")
            }
        }.navigationTitle("New Aircraft")
    }
    
    private func addAircraft(name: String, propellerSize: String, weight: String) {
        
        withAnimation {
           
            let aircraft = Aircraft(context: viewContext);
            
            aircraft.name = name;
            aircraft.propellerSize = Float(propellerSize) ?? 5.0;
            aircraft.weight = Int64(weight) ?? 0;
            
            PersistenceController.shared.save();
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AircraftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Aircraft.entity(), sortDescriptors: [])
    private var aircraft: FetchedResults<Aircraft>
    
    private func deleteAircraft(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                aircraft[$0]
            }.forEach(viewContext.delete)

            PersistenceController.shared.save();
        }
    }
    
    var body: some View {
        List {
            ForEach(aircraft) { a in
                AircraftRow(aircraft: a)
            }.onDelete(perform: deleteAircraft)
        }
        .navigationTitle("Aircraft")
        .toolbar {
            NavigationLink(destination: NewAircraftView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct AircraftView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftView()
    }
}
