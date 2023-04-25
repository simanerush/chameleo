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
        VStack {
            Text("Current User Identifier")
                .font(.headline)
                .padding(.bottom, 8.0)
                .padding(.top, 16.0)

            Text(Purchases.shared.appUserID)

            Text("Subscription Status")
                .font(.headline)
                .padding([.top, .bottom], 8.0)

            Text(model.subscriptionActive ? "Active" : "Not Active")
                .foregroundColor(model.subscriptionActive ? .green : .red)

            Button("Restore Purchases") {
                Task {
                    try? await Purchases.shared.restorePurchases()
                }
            }
            .foregroundColor(.blue)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 64.0)

        }.padding(.all, 16.0)
    }
}
