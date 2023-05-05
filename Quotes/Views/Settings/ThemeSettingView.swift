//
//  ThemeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/18/23.
//

import SwiftUI

struct ThemeSettingView: View {

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  @State private var preset1BackgroundColor = Color.pink
  @State private var preset1FontColor = Color.white

  @State private var preset2BackgroundColor = Color.pink
  @State private var preset2FontColor = Color.white

  @State private var preset3BackgroundColor = Color.pink
  @State private var preset3FontColor = Color.white

  @State private var preset4BackgroundColor = Color.pink
  @State private var preset4FontColor = Color.white

  @State private var preset5BackgroundColor = Color.pink
  @State private var preset5FontColor = Color.white

  var body: some View {
    Form {
      Section("Theme") {
        ColorPicker("Background color", selection: $backgroundColor)
        ColorPicker("Font color", selection: $fontColor)
      }
      Section("Presets") {
        PresetView(backgroundColor: $backgroundColor,
                   fontColor: $fontColor,
                   presetBackgroundColor: $preset1BackgroundColor,
                   presetFontColor: $preset1FontColor)
      }
      .listRowBackground(Color.clear)
      Section("Preview") {

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
  }
}

struct PresetView: View {

  @Binding var backgroundColor: Color
  @Binding var fontColor: Color

  @Binding var presetBackgroundColor: Color
  @Binding var presetFontColor: Color

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.pink)
      Circle()
        .fill(fontColor)
        .offset(x: 17, y: 17)
    }
    .frame(width: 50, height: 70)
    .onTapGesture {
      backgroundColor = presetBackgroundColor
      fontColor = presetFontColor
    }
  }
}
