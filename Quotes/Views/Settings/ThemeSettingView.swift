//
//  ThemeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/18/23.
//

import SwiftUI

struct ThemeSettingView: View {
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  var body: some View {
    Form {
      Section("theme") {
        ColorPicker("background color", selection: $backgroundColor)
        ColorPicker("font color", selection: $fontColor)
      }
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
  }
}
