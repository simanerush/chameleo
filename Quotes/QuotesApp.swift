//
//  QuotesApp.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI
import WidgetKit

@main
struct QuotesApp: App {
  let persistenceController = PersistenceController.shared
  let model: QuoteModel

  init() {
    self.model = QuoteModel(persistenceController: persistenceController)
    WidgetCenter.shared.reloadAllTimelines()
  }

  var body: some Scene {
    WindowGroup {
      RandomQuoteView(model: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
