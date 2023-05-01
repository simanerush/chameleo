//
//  KeyValueStore.swift
//  Quotes
//
//  Created by Sima Nerush on 4/30/23.
//

import Foundation

class KeyValueStore: ObservableObject {

  static let shared = KeyValueStore()

  private let keyValueStore = NSUbiquitousKeyValueStore.default

  func save(value: Any, forKey key: String) {
    keyValueStore.set(value, forKey: key)
    keyValueStore.synchronize()
  }

  func retrieveInt(forKey key: String) -> Int? {
    if keyValueStore.object(forKey: key) != nil {
      return Int(keyValueStore.longLong(forKey: key))
    } else {
      return nil
    }
  }

  func removeValue(forKey key: String) {
    keyValueStore.removeObject(forKey: key)
    keyValueStore.synchronize()
  }
}
