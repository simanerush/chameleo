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

  init() {
    WidgetCenter.shared.reloadAllTimelines()
  }

  var body: some Scene {
    WindowGroup {
      QuoteView(model: QuoteModel.shared)
    }
  }
}
