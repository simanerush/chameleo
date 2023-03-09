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
      MainView(model: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .onAppear {
          for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                      
            for name in UIFont.fontNames(forFamilyName: sName) {
              print("name: \(name as String)")
            }
          }
        }
    }
  }
}
