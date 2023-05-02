//
//  NavigationContext.swift
//  Quotes
//
//  Created by Sima Nerush on 5/1/23.
//

import Foundation

class NavigationContext: ObservableObject {
  @Published var navToHome = false
  @Published var selectedTab = ""
}
