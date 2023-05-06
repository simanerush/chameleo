//
//  ContentView.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI

struct QuoteView: View {

  @ObservedObject var model: QuoteModel

  private let defaults = UserDefaults.standard

  var body: some View {
    ZStack {
      RadialGradient(gradient:
                      Gradient(
                        colors: [ChameleoUI.backgroundColor, .black]),
                        center: .center, startRadius: 2, endRadius: 170)
        .ignoresSafeArea()
      VStack {
        Text(quoteOfTheDay)
          .padding(5)
          .font(ChameleoUI.quoteOfTheDayFont)
          .foregroundColor(ChameleoUI.textColor)
          .minimumScaleFactor(0.01)
          .onChange(of: model.quoteOfTheDay) { newQuote in
            defaults.set(newQuote, forKey: "WatchQuote")
          }
      }
    }
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }

  private var quoteOfTheDay: String {
    if model.quoteOfTheDay == "You don't have any quotes!" {
      return defaults.object(forKey: "WatchQuote") as? String ??
      "Open Chameleo on your iPhone for setting up the Watch app"
    } else {
      return model.quoteOfTheDay
    }
  }
}
