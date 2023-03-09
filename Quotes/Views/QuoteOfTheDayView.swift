//
//  QuoteOfTheDayView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI

struct QuoteOfTheDayView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var model: QuoteModel
  
  @State private var showTabBar = true
  @State private var showQuotes = false
  @State private var showSettings = false
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = AppColors.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = AppColors.textColor
  
  var body: some View {
    ZStack {
      backgroundColor
        .edgesIgnoringSafeArea(showTabBar ? [.top, .horizontal] : [.top, .horizontal, .bottom])
      VStack {
        Text(model.quoteOfTheDay)
          .padding(5)
          .font(.custom("DelaGothicOne-Regular", size: 50))
          .foregroundColor(fontColor)
          .minimumScaleFactor(0.01)
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    }
    .onTapGesture {
      withAnimation(.easeInOut) {
        showTabBar.toggle()
      }
    }
    .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
  }
}
