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

  @State private var editMode: EditMode = .inactive
  @State private var textField = ""
  @State private var alertIsPresented = false

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    List {
      HStack {
        TextField("new quote", text: $textField)
          .font(.custom("FiraMono-Medium", size: 20))
          .padding(5)
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
            .foregroundColor(Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00)))
        }
      }
      ForEach(items) { item in
        Text(item.title!)
          .font(.custom("FiraMono-Medium", size: 20))
          .padding(5)
          .opacity(0.7)
      }
      .onDelete(perform: deleteItems)
    }
    .opacity(0.98)
    .scrollContentBackground(.hidden)
    .background(Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00)))
    .alert("🚨failed to add the quote!", isPresented: $alertIsPresented) {
      Button("ok", role: .cancel) {}
    }
    .navigationBarBackButtonHidden(true)
    .environment(\.editMode, $editMode)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: goBack) {
          Label("", systemImage: "arrow.backward")
        }
        .foregroundColor(.white)
        .bold()
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          if editMode == .inactive {
            editMode = .active
          } else {
            editMode = .inactive
          }
        } label: {
          Text(editMode == .inactive ? "edit" : "done")
            .foregroundColor(.white)
            .font(.headline)
            .bold()
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

struct QuotesListView_Previews: PreviewProvider {
  static var previews: some View {
    QuotesListView(model: QuoteModel(persistenceController: PersistenceController.shared))
  }
}
