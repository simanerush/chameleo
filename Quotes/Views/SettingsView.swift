//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  var body: some View {
    Form {
      Section("theme") {
        ColorPicker("background color", selection: $backgroundColor)
        ColorPicker("font color", selection: $fontColor)
      }
      //      TODO
      //      Section("widget") {
      //        Text("frequency of widget update")
      //      }
      Section {
        Button {
          backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
          fontColor = .white
        } label: {
          Text("reset settings")
            .foregroundColor(.blue)
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
        .foregroundColor(.blue)
        .bold()
      }
    }
    .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
  }
  
  private func goBack() {
    self.presentationMode.wrappedValue.dismiss()
  }
}
