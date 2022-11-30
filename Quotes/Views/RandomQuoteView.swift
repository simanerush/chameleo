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
  @State var showSettings = false
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white

  var body: some View {
    NavigationStack {
      ZStack {
        backgroundColor.ignoresSafeArea()
        VStack {
          Text(model.getTodayQuote())
            .padding(5)
            .font(.custom("DelaGothicOne-Regular", size: 50))
            .foregroundColor(fontColor)
            .minimumScaleFactor(0.01)
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              showSettings.toggle()
            } label: {
              Image(systemName: "gear")
                .foregroundColor(fontColor)
                .bold()
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              showQuotes.toggle()
            } label: {
              Text("my quotes")
                .foregroundColor(fontColor)
                .font(.headline)
                .bold()
            }
          }
        }
        .navigationBarTitleDisplayMode(.inline)
        .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
      }
      .navigationDestination(isPresented: $showQuotes) {
        QuotesListView(model: model)
          .navigationBarTitleDisplayMode(.inline)
      }
      .navigationDestination(isPresented: $showSettings) {
        SettingsView()
          .navigationBarTitleDisplayMode(.large)
      }
    }
  }
}

struct RandomQuoteView_Previews: PreviewProvider {
  static var previews: some View {
    RandomQuoteView(model: QuoteModel(persistenceController: PersistenceController.shared))
  }
}
