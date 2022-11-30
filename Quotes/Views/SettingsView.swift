//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  @AppStorage("backgroundColor") private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  @AppStorage("fontColor") private var fontColor: Color = .white
  
  var body: some View {
    Form {
      Section("appearance") {
        ColorPicker("background color", selection: $backgroundColor)
        ColorPicker("font color", selection: $fontColor)
      }
      Section("widget") {
        Text("frequency of widget update")
      }
      Section {
        Button {
          backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
          fontColor = .white
        } label: {
          Text("reset settings")
            .foregroundColor(backgroundColor)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationTitle("⚙️settings")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: goBack) {
          Label("", systemImage: "arrow.backward")
        }
        .foregroundColor(backgroundColor)
        .bold()
      }
    }
  }
  
  private func goBack() {
    self.presentationMode.wrappedValue.dismiss()
  }
}
