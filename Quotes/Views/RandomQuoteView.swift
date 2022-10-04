//
//  RandomQuoteView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI

struct RandomQuoteView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var model: QuoteModel

  @State var showQuotes = false

  var body: some View {
    NavigationView {
      VStack {
        Text(model.getTodayQuote())
        NavigationLink(destination: QuotesListView(model: model).navigationBarHidden(true),
                       isActive: $showQuotes) {}
      }
      .toolbar {
        ToolbarItem {
          Button("My Quotes") {
            showQuotes.toggle()
          }
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}
