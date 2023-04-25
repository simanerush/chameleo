//
//  QuotesApp.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI
import WidgetKit
import RevenueCat

@main
struct QuotesApp: App {
  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(
        with: Configuration.Builder(withAPIKey: Constants.purchasesKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
    )
    Purchases.shared.delegate = PurchasesDelegateHandler.shared

    WidgetCenter.shared.reloadAllTimelines()
    GPTCaller.shared.setup()
  }

  var body: some Scene {
    WindowGroup {
      MainView(model: QuoteModel.shared)
        .environment(\.managedObjectContext, QuoteModel.shared.persistenceController.container.viewContext)
        .accentColor(backgroundColor)
        .task {
            do {
                // Fetch the available offerings
                SubscriptionModel.shared.offerings = try await Purchases.shared.offerings()
                print("successfully fethced offerings \(SubscriptionModel.shared.offerings!.description)")
            } catch {
                print("Error fetching offerings: \(error)")
            }
        }
    }
  }
}
