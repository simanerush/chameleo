//
//  SettingsView.swift
//  Quotes
//
//  Created by Sima Nerush on 11/29/22.
//

import SwiftUI

struct SettingsView: View {

  let settings: Array<Setting> = [Setting(title: "theme", color: .red, imageName: "heart.square.fill")]
  
  var body: some View {
    NavigationStack {
      List(settings, id: \.self) { setting in
        NavigationLink(destination: ThemeSettingView()) {
          HStack {
            SectionImage(name: "heart.square.fill", color: .red)
            Text("theme")
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
  let name: String
  let color: Color
  
  var body: some View {
    Image(systemName: "heart.square.fill")
      .resizable()
      .foregroundStyle(color)
      .frame(width: 25, height: 25)
  }
}
