//
//  ThemeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/18/23.
//

import SwiftUI

struct ThemeSettingView: View {

  @Environment(\.colorScheme) var colorScheme

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  private var presets = [
    Preset(backgroundColor: Color(uiColor: UIColor(red: 0.42, green: 0.69, blue: 0.30, alpha: 1.00)),
           fontColor: Color(uiColor: UIColor(red: 0.87, green: 0.98, blue: 0.98, alpha: 1.00))),
    Preset(backgroundColor: Color(uiColor: UIColor(red: 0.97, green: 0.56, blue: 0.70, alpha: 1.00)),
           fontColor: Color(uiColor: UIColor(red: 0.34, green: 0.29, blue: 0.56, alpha: 1.00))),
    Preset(backgroundColor: Color(uiColor: UIColor(red: 0.44, green: 0.63, blue: 1.00, alpha: 1.00)),
           fontColor: .white),
    Preset(backgroundColor: Color(uiColor: UIColor(red: 0.18, green: 0.21, blue: 0.26, alpha: 1.00)),
           fontColor: Color(uiColor: UIColor(red: 0.87, green: 0.89, blue: 0.92, alpha: 1.00)))
  ]

  var body: some View {
    Form {
      Section("Edit Theme") {
        ColorPicker("Background color", selection: $backgroundColor)
        ColorPicker("Font color", selection: $fontColor)
      }
      Section("Preview") {
        ZStack {
          LinearGradient(gradient:
                          Gradient(
                            colors: [backgroundColor, colorScheme == .dark ? .black : backgroundColor.opacity(0.3)]),
                         startPoint: .topTrailing,
                         endPoint: .bottomLeading)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          VStack {
            Text("My awesome quote!")
              .padding(5)
              .font(ChameleoUI.quoteOfTheDayFont)
              .foregroundColor(fontColor)
              .minimumScaleFactor(0.01)
          }
        }
      }
      .listRowBackground(Color.clear)
      Section("Presets") {
        HStack {
          ForEach(presets, id: \.self) { preset in
            PresetView(backgroundColor: $backgroundColor,
                       fontColor: $fontColor,
                       presetBackgroundColor: preset.backgroundColor,
                       presetFontColor: preset.fontColor)
            .frame(maxWidth: .infinity)
          }
        }
      }
      .listRowBackground(Color.clear)
      Section {
        Button {
          backgroundColor = ChameleoUI.backgroundColor
          fontColor = ChameleoUI.textColor
        } label: {
          Text("Reset settings")
        }
      }
    }
  }
}

struct Preset: Hashable {
  let backgroundColor: Color
  let fontColor: Color
}

struct PresetView: View {

  @Binding var backgroundColor: Color
  @Binding var fontColor: Color

  var presetBackgroundColor: Color
  var presetFontColor: Color

  init(backgroundColor: Binding<Color>,
       fontColor: Binding<Color>,
       presetBackgroundColor: Color,
       presetFontColor: Color) {
    self._backgroundColor = backgroundColor
    self._fontColor = fontColor
    self.presetBackgroundColor = presetBackgroundColor
    self.presetFontColor = presetFontColor
  }

  var body: some View {
    ZStack {
      Circle()
        .fill(presetBackgroundColor)
      Circle()
        .fill(presetFontColor)
        .offset(x: 17, y: 17)
    }
    .frame(width: 50, height: 70)
    .onTapGesture {
      backgroundColor = presetBackgroundColor
      fontColor = presetFontColor
    }
  }
}
