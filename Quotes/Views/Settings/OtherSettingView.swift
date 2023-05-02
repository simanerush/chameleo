//
//  OtherSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 5/1/23.
//

import SwiftUI

struct OtherSettingView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var context: NavigationContext
  @Environment(\.presentationMode) private var presentationMode

  @State private var showAlert = false

  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
      ],
    animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    Form {
      Section("danger zone⚠️") {
        Button {
          showAlert = true
        } label: {
          Text("Delete all stored quotes")
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Confirm your action"),
                message: Text("Do you want to delete all of your quotes? This action cannot be undone."),
                primaryButton: .default(Text("Yes"), action: {
            items.forEach { viewContext.delete($0)}
            if viewContext.hasChanges { try? viewContext.save() }
          }),
                secondaryButton: .cancel(Text("No")))
        }
      }
    }
    .onChange(of: context.navToHome) { _ in
      presentationMode.wrappedValue.dismiss()
    }
  }
}

struct OtherSettingView_Previews: PreviewProvider {
  static var previews: some View {
    OtherSettingView()
  }
}
