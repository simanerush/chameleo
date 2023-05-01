//
//  SubscriptionSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 4/19/23.
//

import SwiftUI
import RevenueCat

struct SubscriptionSettingView: View {
  @ObservedObject var model = SubscriptionModel.shared

  @State var newUserId: String = ""

  var body: some View {
    Form {
      HStack {
        Text("Subscription Status")
        Spacer()
        Text(model.subscriptionActive ? "Active" : "Not Active")
          .bold()
          .foregroundColor(model.subscriptionActive ? .green : .red)
      }
      Button("Restore Purchases") {
        Task {
          try? await Purchases.shared.restorePurchases()
        }
      }
    }
  }
}
