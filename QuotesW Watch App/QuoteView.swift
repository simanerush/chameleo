//
//  ContentView.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI

struct QuoteView: View {
  @ObservedObject var model: QuoteModel
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var fontColor: Color = .white
  
  var body: some View {
    ZStack {
      backgroundColor
        .ignoresSafeArea()
      VStack {
        Text(model.getTodayQuote())
          .padding(5)
          .font(.custom("DelaGothicOne-Regular", size: 50))
          .foregroundColor(fontColor)
          .minimumScaleFactor(0.01)
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    }
  }
}
