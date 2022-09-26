//
//  QuotesApp.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI

@main
struct QuotesApp: App {
  let persistenceController = PersistenceController.shared
  let model: QuoteModel
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")

  init() {
    // When the day changes, update the quote
    self.model = QuoteModel(persistenceController: persistenceController)
    if let storedQuote = UserDefaults.standard.array(forKey: "todaysQuote") {
      if storedQuote.first! as! Date != Date.today {
        model.computeRandomQuote()
      }
    } else if UserDefaults.standard.array(forKey: "todaysQuote") == nil {
       model.computeRandomQuote()
    }
  }

  var body: some Scene {
    WindowGroup {
      RandomQuoteView(model: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
