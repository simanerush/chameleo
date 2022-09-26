//
//  QuoteModel.swift
//  Quotes
//
//  Created by Sima Nerush on 9/3/22.
//

import CoreData

class QuoteModel: ObservableObject {
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")
  let persistenceController: PersistenceController

  init(persistenceController: PersistenceController) {
    self.persistenceController = persistenceController
  }

  func getTodayQuote() -> String {
    if let quote = defaults!.array(forKey: "todaysQuote") {
      return quote[1] as! String
    } else {
      return "You don't have any quotes!"
    }
  }

  func computeRandomQuote() {
    // TODO: - If there's no quote saved already, compute a new one (save + return). Else, return the one that is stored already.

    var fetchedQuotes = [String]()

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
    do {
      if let results = try persistenceController.container.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
        for result in results {
          if let title = result.value(forKey: "title") as? String {
            fetchedQuotes.append(title)
          }
        }
      }
    } catch {
      print("Failed to fetch data request.")
    }
    if !fetchedQuotes.isEmpty {
      defaults!.set([Date.today, fetchedQuotes.randomElement() as Any], forKey: "todaysQuote")
    }
  }
}
