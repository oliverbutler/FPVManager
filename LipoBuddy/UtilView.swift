//
//  UtilView.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 23/03/2021.
//

import SwiftUI

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



struct StepperView: View {
    @State var value: Int;

    func incrementStep() {
        self.value += 1
    }

    func decrementStep() {
        self.value -= 1
    }

    var body: some View {
        Stepper(onIncrement: incrementStep,
            onDecrement: decrementStep) {
            VStack(alignment: .leading, spacing: 2) {
            Text("Cell Count")
                .font(.caption)
                .foregroundColor(Color(.placeholderText))
            Text(String(value))
            }
        }
    }
}
