//
//  RootSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/19/23.
//

import SwiftUI

struct RootSettingView: View {
  let viewToDisplay: String
  var body: some View {
    switch viewToDisplay {
    case "Theme":
      ThemeSettingView()
    case "Widget":
      WidgetSettingView()
    case "Other":
      OtherSettingView()
    default:
      EmptyView()
    }
  }
}
