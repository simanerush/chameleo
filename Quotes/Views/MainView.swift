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
          Label("", systemImage: "star.fill")
        }
      QuotesListView(model: model)
        .tabItem {
          Label("", systemImage: "list.bullet.rectangle.portrait")
        }
      SettingsView()
        .tabItem {
          Label("", systemImage: "wand.and.stars")
        }
    }
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }
}
