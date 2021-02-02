//
//  ContentView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import SwiftUI

struct ContentView: View {

//    var batteries = [Int]();
//    batteries.append(100);
//    batteries.append(80);
    
    var body: some View {
        ZStack {
            VStack {
                Text("LippoBuddy")
                    .bold()
                    .font(.system(size: 32))
                    .padding()
                
                List {
                    Text("battery 1")
                    Text("battery 2")
                }
                
                Spacer()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

