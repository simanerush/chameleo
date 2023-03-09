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
  
  @Published private(set) var quoteOfTheDay: String = ""
  
  init(persistenceController: PersistenceController) {
    self.persistenceController = persistenceController
  }
  
  func setQuoteOfTheDay() {
    
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
      if quotesIsEmpty() {
        // nil the defaults if the user deleted all quotes
        quoteOfTheDay = "you don't have any quotes!"
        defaults.set(nil, forKey: "todaysQuote")
      } else { quoteOfTheDay = quote[1] as! String }
    } else {
      quoteOfTheDay = "you don't have any quotes!"
    }
  }
  
  private func fetchAllQuotes() -> [String] {
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
    
    return fetchedQuotes
  }
  
  private func computeRandomQuote() {
    let fetchedQuotes = fetchAllQuotes()
    if !fetchedQuotes.isEmpty {
      defaults.set([Date(), fetchedQuotes.randomElement() as Any], forKey: "todaysQuote")
    }
  }
  
  private func quotesIsEmpty() -> Bool {
    return fetchAllQuotes().isEmpty
  }
  
  func makeTodayQuote(item: Item) {
    guard let title = item.title else { fatalError("quote has a nil title") }
    defaults.set([Date(), title], forKey: "todaysQuote")
    quoteOfTheDay = title
  }
}
