//
//  MainView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/16/23.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var context: NavigationContext

  @ObservedObject var model: QuoteModel

  var body: some View {
    TabView(selection: $context.selectedTab) {
      QuoteOfTheDayView(model: model)
        .tabItem {
          Label("", systemSymbol: .starFill)
        }
        .tag("QuoteOfTheDay")
      QuotesListView(model: model)
        .tabItem {
          Label("", systemSymbol: .listBulletRectanglePortrait)
        }
        .tag("QuotesList")
      GeneratedQuoteView(model: model)
        .tabItem {
          Label("", systemSymbol: .wandAndStars)
        }
        .tag("GeneratedQuote")
      SettingsView()
        .tabItem {
          Label("", systemSymbol: .gear)
        }
        .tag("Settings")
    }
    .onReceive(context.$selectedTab) { _ in
      context.navToHome.toggle()
    }
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }
}
