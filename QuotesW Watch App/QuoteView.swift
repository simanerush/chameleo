//
//  ContentView.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI

struct QuoteView: View {
  @ObservedObject var model: QuoteModel
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var backgroundColor = AppColors.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) var fontColor: Color = AppColors.textColor
  
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
