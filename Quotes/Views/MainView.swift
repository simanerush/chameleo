//
//  MainView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/16/23.
//

import SwiftUI

struct MainView: View {

  @ObservedObject var model: QuoteModel

  var body: some View {
    TabView {
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
        .navigationViewStyle(.stack)
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
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }
}
