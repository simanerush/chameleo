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
  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  init() {
    WidgetCenter.shared.reloadAllTimelines()
    GPTCaller.shared.setup()
  }

  var body: some Scene {
    WindowGroup {
      MainView(model: QuoteModel.shared)
        .environment(\.managedObjectContext, QuoteModel.shared.persistenceController.container.viewContext)
        .accentColor(backgroundColor)
    }
  }
}
