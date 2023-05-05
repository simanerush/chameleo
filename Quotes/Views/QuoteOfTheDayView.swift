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
  @State private var startAnimation = false

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  var body: some View {
    ZStack {
      LinearGradient(gradient:
                      Gradient(
                        colors: [backgroundColor, colorScheme == .dark ? .black : backgroundColor.opacity(0.3)]),
                     startPoint: startAnimation ? .topLeading : .topTrailing,
                     endPoint: startAnimation ? .bottomTrailing : .bottomLeading)

      .edgesIgnoringSafeArea(showTabBar ? [.top, .horizontal] : [.top, .horizontal, .bottom])
      .onAppear {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
          startAnimation.toggle()
        }
      }
      Text(model.quoteOfTheDay)
        .padding(15)
        .font(ChameleoUI.quoteOfTheDayFont)
        .foregroundColor(fontColor)
        .minimumScaleFactor(0.01)
    }
    .onTapGesture {
      withAnimation {
        showTabBar.toggle()
      }
    }
    .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
  }
}
