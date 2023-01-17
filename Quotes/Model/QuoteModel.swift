//
//  QuoteModel.swift
//  Quotes
//
//  Created by Sima Nerush on 9/3/22.
//

import CoreData

class QuoteModel: ObservableObject {
  let persistenceController: PersistenceController
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")!
  
  init(persistenceController: PersistenceController) {
    self.persistenceController = persistenceController
  }
  
  /// fetch today's quote
  func getTodayQuote() -> String {
    if let storedQuote = defaults.array(forKey: "todaysQuote") {
      // if the date of the stored quote is different from the current date,
      // recompute the quote
      let storedQuoteDate = storedQuote.first! as! Date
      if !storedQuoteDate.hasSameOfMultiple([.day, .month, .year], as: Date()) {
        self.computeRandomQuote()
      }
    } else if defaults.array(forKey: "todaysQuote") == nil {
      // also recompute the quote if there is no quote stored
      self.computeRandomQuote()
    }
    
    if let quote = defaults.array(forKey: "todaysQuote") {
      // finally, return quote of the day
      return quote[1] as! String
    } else {
      return "you don't have any quotes!"
    }
  }
  
  func computeRandomQuote() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
    var fetchedQuotes = [String]()
    
    // fetch all quotes first
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
      defaults.set([Date(), fetchedQuotes.randomElement() as Any], forKey: "todaysQuote")
    }
  }
}
