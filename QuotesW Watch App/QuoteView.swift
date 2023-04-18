//
//  ContentView.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI

struct QuoteView: View {

  @ObservedObject var model: QuoteModel

  var body: some View {
    ZStack {
      RadialGradient(gradient:
                      Gradient(
                        colors: [ChameleoUI.backgroundColor, .black]),
                        center: .center, startRadius: 2, endRadius: 170)
        .ignoresSafeArea()
      VStack {
        Text(model.quoteOfTheDay)
          .padding(5)
          .font(ChameleoUI.quoteOfTheDayFont)
          .foregroundColor(ChameleoUI.textColor)
          .minimumScaleFactor(0.01)
      }
    }
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }
}
