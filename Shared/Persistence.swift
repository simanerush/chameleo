//
//  Persistence.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import CoreData
import CloudKit

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentCloudKitContainer

  /// initialize the database in memory
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Quotes")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
