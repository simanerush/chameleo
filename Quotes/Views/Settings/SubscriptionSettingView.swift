//
//  SubscriptionSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 4/19/23.
//

import SwiftUI
import RevenueCat

struct SubscriptionSettingView: View {
  @EnvironmentObject var context: NavigationContext
  @Environment(\.presentationMode) private var presentationMode

  @ObservedObject var model = SubscriptionModel.shared

  @State var newUserId: String = ""

  var body: some View {
    Form {
      HStack {
        Text("Chameleo Plus Subscription")
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
    .onChange(of: context.navToHome) { _ in
      presentationMode.wrappedValue.dismiss()
    }
  }
}
