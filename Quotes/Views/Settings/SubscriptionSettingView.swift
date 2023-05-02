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

  @State var errorAlertPresented = false
  @State var successAlertPresented = false
  @State var successText = ""

  @State var isRestoringPurchases = false

  var body: some View {
    Form {
      HStack {
        Text("Chameleo Plus Subscription")
        Spacer()
        Text(model.subscriptionActive ? "Active" : "Not Active")
          .bold()
          .foregroundColor(model.subscriptionActive ? .green : .red)
      }
      if !isRestoringPurchases {
        Button {
          isRestoringPurchases = true
          Task {
            let result: Result = await restorePurchases()
            switch result {
            case .success(let text):
              successAlertPresented.toggle()
              successText = text
            case .failure:
              errorAlertPresented.toggle()
            }
            isRestoringPurchases = false
          }
        } label: {
          Text("Restore Purchases")
        }
        .alert(isPresented: $successAlertPresented) {
          Alert(title: Text("Success!"),
                message: Text(successText),
                dismissButton: .default(Text("Ok"))
          )
        }
      } else {
        ProgressView()
      }
    }
    .alert(isPresented: $errorAlertPresented) {
      Alert(title: Text("Error!"),
            message: Text("Somehing went wrong"),
            dismissButton: .default(Text("Ok"))
      )
    }
    .onChange(of: context.navToHome) { _ in
      presentationMode.wrappedValue.dismiss()
    }
  }

  private func restorePurchases() async -> Result<String, Error> {
    let restoreTask = Task { () -> CustomerInfo in
      let customerInfo: CustomerInfo

      do {
        customerInfo = try await Purchases.shared.restorePurchases()
      } catch {
        throw error
      }

      return customerInfo
    }

    let result = await restoreTask.result

    do {
      let customerInfo = try result.get()
      if customerInfo.entitlements[Constants.purchasesEntitlementID]?
        .isActive == true {
        return Result.success("Your subscription was successfully restored!")
      }
      return Result.success("You do not have an active Chameleo Plus subscription")
    } catch {
      return Result.failure(error)
    }
  }
}
