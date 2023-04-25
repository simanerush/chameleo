//
//  PurchasesDelegateHandler.swift
//  Quotes
//
//  Created by Sima Nerush on 4/19/23.
//

import Foundation
import RevenueCat

class PurchasesDelegateHandler: NSObject, ObservableObject {

  static let shared = PurchasesDelegateHandler()

}

extension PurchasesDelegateHandler: PurchasesDelegate {

  func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
    SubscriptionModel.shared.customerInfo = customerInfo
  }

  func purchases(_ purchases: Purchases,
                 readyForPromotedProduct product: StoreProduct,
                 purchase startPurchase: @escaping StartPurchaseBlock) {
    startPurchase { (_, info, error, cancelled) in
      if let info = info, error == nil, !cancelled {
        SubscriptionModel.shared.customerInfo = info
      }
    }
  }

}
