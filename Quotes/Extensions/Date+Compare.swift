//
//  Date+Compare.swift
//  Quotes
//
//  Created by Sima Nerush on 10/4/22.
//

import Foundation

extension Date {

  func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
    let days1 = calendar.component(component, from: self)
    let days2 = calendar.component(component, from: date)
    return days1 - days2
  }

  func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
    distance(from: date, only: component) == 0
  }

  func hasSameOfMultiple(_ components: [Calendar.Component], as date: Date) -> Bool {
    components.allSatisfy({hasSame($0, as: date)})
  }
}
