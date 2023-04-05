//
//  WidgetUpdateFrequency.swift
//  Quotes
//
//  Created by Sima Nerush on 2/16/23.
//

import Foundation

enum WidgetUpdateFrequency: String {
  typealias RawValue = String

  case daily
  case hourly
}

extension WidgetUpdateFrequency: RawRepresentable {

  init?(rawValue: Int) {
    switch rawValue {
    case 0:
      self = .daily
    case 1:
      self = .hourly
    default:
      return nil
    }
  }
}

extension WidgetUpdateFrequency: CaseIterable {

  func stringValue() -> String {
    switch self {
    case .daily:
      return "daily"
    case .hourly:
      return "hourly"
    }
  }
}
