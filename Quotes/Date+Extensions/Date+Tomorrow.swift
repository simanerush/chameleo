//
//  Date+Tomorrow.swift
//  QuotesWidgetExtension
//
//  Created by Sima Nerush on 9/8/22.
//

import Foundation

extension Date {
   static var tomorrow:  Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}
