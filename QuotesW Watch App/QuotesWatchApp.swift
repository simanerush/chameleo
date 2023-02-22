//
//  QuotesWatchApp.swift
//  QuotesWatch
//
//  Created by Sima Nerush on 2/21/23.
//

import SwiftUI
import WidgetKit

@main
struct QuotesWatchApp: App {
  let persistenceController = PersistenceController.shared
  let model: QuoteModel
  
  init() {
    self.model = QuoteModel(persistenceController: persistenceController)
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  var body: some Scene {
    WindowGroup {
      QuoteView(model: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
