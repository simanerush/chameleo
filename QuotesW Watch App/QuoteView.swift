//
//  ContentView.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI

struct QuoteView: View {
  @ObservedObject var model: QuoteModel
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var backgroundColor = ChameleoUI.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var fontColor: Color = ChameleoUI.textColor
  
  var body: some View {
    ZStack {
      RadialGradient(gradient: Gradient(colors: [backgroundColor, .black]), center: .center, startRadius: 2, endRadius: 170)
        .ignoresSafeArea()
      VStack {
        Text(model.quoteOfTheDay)
          .padding(5)
          .font(ChameleoUI.quoteOfTheDayFont)
          .foregroundColor(fontColor)
          .minimumScaleFactor(0.01)
      }
    }
    .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    .onAppear {
      model.setQuoteOfTheDay()
    }
  }
}
