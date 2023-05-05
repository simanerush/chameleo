//
//  ThemeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/18/23.
//

import SwiftUI

struct ThemeSettingView: View {
  @EnvironmentObject var context: NavigationContext
  @Environment(\.presentationMode) private var presentationMode

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  var body: some View {
    Form {
      Section("Theme") {
        ColorPicker("Background color", selection: $backgroundColor)
        ColorPicker("Font color", selection: $fontColor)
      }
      Section {
        Button {
          backgroundColor = ChameleoUI.backgroundColor
          fontColor = ChameleoUI.textColor
        } label: {
          Text("Reset settings")
            .foregroundColor(.blue)
        }
      }
    }
    .onChange(of: context.navToHome) { _ in
      presentationMode.wrappedValue.dismiss()
    }
  }
}
