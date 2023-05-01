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
    case "theme":
      ThemeSettingView()
    case "widget":
      WidgetSettingView()
    case "manage subscription":
      SubscriptionSettingView()
    case "other":
      OtherSettingView()
    case "about me":
      AboutMeSettingView()
    default:
      EmptyView()
    }
  }
}
