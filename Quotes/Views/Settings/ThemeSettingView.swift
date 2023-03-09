//
//  ThemeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/18/23.
//

import SwiftUI

struct ThemeSettingView: View {
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  
  var body: some View {
    Form {
      Section("theme") {
        ColorPicker("background color", selection: $backgroundColor)
        ColorPicker("font color", selection: $fontColor)
      }
      Section {
        Button {
          backgroundColor = ChameleoUI.backgroundColor
          fontColor = ChameleoUI.textColor
        } label: {
          Text("reset settings")
            .foregroundColor(.blue)
        }
      }
    }
  }
}
