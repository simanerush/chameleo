//
//  ContentView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  @State private var textField = ""

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationView {
      List {
        HStack {
          TextField("New Quote", text: $textField)
          Button {
            if !textField.isEmpty {
              let newQuote = Item(context: viewContext)
              newQuote.timestamp = Date()
              newQuote.title = textField
              addItem(newItem: newQuote)
              textField = ""
            }
          } label: {
            Image(systemName: "plus")
          }
        }
        ForEach(items) { item in
          Text(item.title!)
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: goBack) {
            Label("", systemImage: "chevron.backward")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
      Text("Select an item")
    }
  }

  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }

  private func goBack() {
    self.presentationMode.wrappedValue.dismiss()
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
