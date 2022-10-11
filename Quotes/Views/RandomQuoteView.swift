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
    NavigationStack {
      ZStack {
        Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00)).ignoresSafeArea()
        VStack {
          Text(model.getTodayQuote())
            .padding(5)
            .font(.custom("DelaGothicOne-Regular", size: 50))
            .foregroundColor(Color(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)))
            .minimumScaleFactor(0.01)
        }
        .toolbar {
          ToolbarItem {
            Button {
              showQuotes.toggle()
            } label: {
              Text("my quotes")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
            }
          }
        }
        .navigationBarTitleDisplayMode(.inline)
      }
      .navigationDestination(isPresented: $showQuotes) {
        QuotesListView(model: model)
          .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}

struct RandomQuoteView_Previews: PreviewProvider {
  static var previews: some View {
    RandomQuoteView(model: QuoteModel(persistenceController: PersistenceController.shared))
  }
}
