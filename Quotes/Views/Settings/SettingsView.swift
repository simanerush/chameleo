//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI
import SFSafeSymbols

struct SettingsView: View {

  let settings: [Setting] = [
    Setting(title: "theme", color: .red, image: .heartSquareFill),
    Setting(title: "widget", color: .yellow, image: .starSquareFill),
    Setting(title: "manage subscription", color: .green, image: .dollarsignSquareFill),
    Setting(title: "other", color: .blue, image: .commandSquareFill),
    Setting(title: "about me", color: .gray, image: .infoSquareFill)
  ]

  var body: some View {
    NavigationStack {
      List {
        ForEach(settings, id: \.self) { setting in
          NavigationLink(destination:
                          RootSettingView(viewToDisplay: setting.title).navigationBarTitleDisplayMode(.inline)) {
            HStack {
              SectionImage(color: setting.color, symbol: setting.image)
              Text(setting.title)
            }
          }
        }
      }
      .navigationTitle("Settings")
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    }
  }
}

struct Setting: Hashable {
  let title: String
  let color: Color
  let image: SFSymbol
}

struct SectionImage: View {
  let color: Color
  let symbol: SFSymbol

  var body: some View {
    Image(systemSymbol: symbol)
      .resizable()
      .foregroundStyle(color)
      .frame(width: 25, height: 25)
  }
}
