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
  
  var body: some Scene {
    WindowGroup {
      RandomQuoteView(model: QuoteModel())
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
