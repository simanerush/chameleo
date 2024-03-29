//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI
import SFSafeSymbols

struct SettingsView: View {

  private let settings: [Setting] = [
    Setting(title: "Theme", color: .red, image: .heartSquareFill),
    Setting(title: "Widget", color: .yellow, image: .starSquareFill),
    Setting(title: "Other", color: .blue, image: .commandSquareFill)
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
      .chameleoNavBar()
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
