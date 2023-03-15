//
//  QuoteOfTheDayView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI

struct QuoteOfTheDayView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var model: QuoteModel
  
  @State private var showTabBar = true
  @State private var showQuotes = false
  @State private var showSettings = false
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  
  var body: some View {
    ZStack {
      RadialGradient(gradient: Gradient(colors: [backgroundColor, colorScheme == .dark ? .black : .white]), center: .center, startRadius: 2, endRadius: 650)
        .edgesIgnoringSafeArea(showTabBar ? [.top, .horizontal] : [.top, .horizontal, .bottom])
      VStack {
        Text(model.quoteOfTheDay)
          .padding(5)
          .font(ChameleoUI.quoteOfTheDayFont)
          .foregroundColor(fontColor)
          .minimumScaleFactor(0.01)
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
    }
    .onTapGesture {
      withAnimation {
        showTabBar.toggle()
      }
    }
    .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
  }
}
