//
//  QuoteModel.swift
//  Quotes
//
//  Created by Sima Nerush on 9/3/22.
//

import CoreData

class QuoteModel: ObservableObject {
  func getRandomQuote() -> String {
    let persistenceController = PersistenceController()

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
    return fetchedQuotes.randomElement() ?? "You don't have any quotes!"
  }
}
