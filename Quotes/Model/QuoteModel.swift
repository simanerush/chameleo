//
//  QuoteModel.swift
//  Quotes
//
//  Created by Sima Nerush on 9/3/22.
//

import CoreData

class QuoteModel: ObservableObject {
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")!
  let persistenceController: PersistenceController

  init(persistenceController: PersistenceController) {
    self.persistenceController = persistenceController
  }

  func getTodayQuote() -> String {
    if let storedQuote = defaults.array(forKey: "todaysQuote") {
      let storedDate = storedQuote.first! as! Date
      if !storedDate.hasSameOfMultiple([.day, .month, .year], as: Date.today) {
        self.computeRandomQuote()
      }
    } else if defaults.array(forKey: "todaysQuote") == nil {
       self.computeRandomQuote()
    }
    
    if let quote = defaults.array(forKey: "todaysQuote") {
      return quote[1] as! String
    } else {
      return "you don't have any quotes!"
    }
  }

  func computeRandomQuote() {
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
      fatalError("🚨failed to fetch data")
    }
    if !fetchedQuotes.isEmpty {
      defaults.set([Date.today, fetchedQuotes.randomElement() as Any], forKey: "todaysQuote")
    }
  }
}
