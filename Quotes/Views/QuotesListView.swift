//
//  QuotesListView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI
import CoreData

struct QuotesListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  @ObservedObject var model: QuoteModel

  @State private var textField = ""
  @State private var alertIsPresented = false

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationView {
      List {
        HStack {
          TextField("new quote", text: $textField)
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
      .alert("🚨failed to add the quote!", isPresented: $alertIsPresented) {
        Button("ok", role: .cancel) {}
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
    }
  }

  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      alertIsPresented.toggle()
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
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}
