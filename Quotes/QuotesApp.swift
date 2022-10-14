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

  init() {
    self.model = QuoteModel(persistenceController: persistenceController)
  }

  var body: some Scene {
    WindowGroup {
      RandomQuoteView(model: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
