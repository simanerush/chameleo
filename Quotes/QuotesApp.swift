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
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")!

  init() {
    // When the day changes, update the quote
    self.model = QuoteModel(persistenceController: persistenceController)
    if let storedQuote = defaults.array(forKey: "todaysQuote") {
      let storedDate = storedQuote.first! as! Date
      if !storedDate.hasSameOfMultiple([.day, .month, .year], as: Date.today) {
        model.computeRandomQuote()
      }
    } else if defaults.array(forKey: "todaysQuote") == nil {
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
