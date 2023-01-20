//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI

struct SettingsView: View {

  let settings: Array<Setting> = [
    Setting(title: "theme", color: .red, imageName: "heart.square.fill"),
    Setting(title: "widget", color: .yellow, imageName: "star.square.fill")
  ]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(settings, id: \.self) { setting in
          NavigationLink(destination: RootSettingView(viewToDisplay: setting.title).navigationBarTitleDisplayMode(.inline)) {
            HStack {
              SectionImage(color: setting.color, imageName: setting.imageName)
              Text(setting.title)
            }
          }
        }
      }
      .navigationTitle("settings!")
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    }
  }
}

struct Setting: Hashable {
  let title: String
  let color: Color
  let imageName: String
}

struct SectionImage: View {
  let color: Color
  let imageName: String
  
  var body: some View {
    Image(systemName: imageName)
      .resizable()
      .foregroundStyle(color)
      .frame(width: 25, height: 25)
  }
}
