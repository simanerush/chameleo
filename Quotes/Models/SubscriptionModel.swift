//
//  SubscriptionModel.swift
//  Quotes
//
//  Created by Sima Nerush on 4/19/23.
//

import Foundation
import RevenueCat
import SwiftUI

class SubscriptionModel: ObservableObject {
  static let shared = SubscriptionModel()

  @Published var customerInfo: CustomerInfo? {
    didSet {
      subscriptionActive = customerInfo?
        .entitlements[Constants.purchasesEntitlementID]?
        .isActive == true
    }
  }

  @Published var offerings: Offerings?
  @Published var subscriptionActive: Bool = false
}
