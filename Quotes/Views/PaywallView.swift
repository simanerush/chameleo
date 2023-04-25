//
//  PaywallView.swift
//  Quotes
//
//  Created by Sima Nerush on 4/19/23.
//

import SwiftUI
import RevenueCat
import SFSafeSymbols

struct PaywallView: View {
  @Binding var isPresented: Bool

  @State
  private(set) var isPurchasing: Bool = false

  @ObservedObject var subscriptionModel = SubscriptionModel.shared

  private var offering: Offering? {
    subscriptionModel.offerings?.current
  }

  private let footerText = "Don't forget to add your subscription terms and conditions. Read more about this here: https://www.revenuecat.com/blog/schedule-2-section-3-8-b"

  @State private var error: NSError?
  @State private var displayError: Bool = false

  @State private var isScaled = false

  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          Image("chameleo")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 100)
          FeaturesOverview()
            .padding(.vertical, 70)
          HStack {
            ForEach(offering?.availablePackages ?? []) { package in
              PackageCellView(package: package) { _ in
                isPurchasing = true

                do {
                  let result = try await Purchases.shared.purchase(package: package)

                  self.isPurchasing = false

                  if !result.userCancelled {
                    self.isPresented = false
                  }
                } catch {
                  self.isPurchasing = false
                  self.error = error as NSError
                  self.displayError = true
                }
              }
            }
          }
        }
        .navigationBarTitle("Chameleo Plus")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)

        /// - Display an overlay during a purchase
        Rectangle()
          .foregroundColor(Color.black)
          .opacity(isPurchasing ? 0.5: 0.0)
          .edgesIgnoringSafeArea(.all)
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .alert(
      isPresented: self.$displayError,
      error: self.error,
      actions: { _ in
        Button(role: .cancel,
               action: { self.displayError = false },
               label: { Text("OK") })
      },
      message: { Text($0.recoverySuggestion ?? "Please try again") }
    )
  }
}

struct FeaturesOverview: View {

  var body: some View {
    VStack(alignment: .leading) {
      Label {
        Text("Ask AI for suggestions more than 5 times")
      } icon: {
        Image(systemSymbol: .checkmarkCircleFill)
          .foregroundColor(.green)
      }
      Label {
        Text("Save unlimited number of quotes")
      } icon: {
        Image(systemSymbol: .checkmarkCircleFill)
          .foregroundColor(.green)
      }
    }
    .padding(.horizontal, 50)
  }
}

struct PackageCellView: View {

  let package: Package
  @State private var packageDuration = ""

  let onSelection: (Package) async -> Void

  var body: some View {
    Button {
      Task {
        await self.onSelection(self.package)
      }
    } label: {
      self.buttonLabel
    }
    .buttonStyle(.bordered)
  }

  private var buttonLabel: some View {
    VStack {
      Text(packageDuration)
        .font(.title3)
        .bold()

      HStack {
        if package.packageType == .annual {
          Text("$12.99")
            .strikethrough()
        }
        Text(package.localizedPriceString)
          .font(.title3)
          .bold()
      }
    }
    .contentShape(Rectangle()) // Make the whole cell tappable
    .onAppear {
      switch package.packageType {
      case .monthly:
        self.packageDuration = "Monthly"
      case .annual:
        self.packageDuration = "Annual"
      default: break
      }
    }
  }
}

extension NSError: LocalizedError {

  public var errorDescription: String? {
    return self.localizedDescription
  }
}
