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
  @State private var editMode: EditMode = .inactive
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: true),
        NSSortDescriptor(keyPath: \Item.userOrder, ascending: true)
      ],
    animation: .default)
  private var items: FetchedResults<Item>
  
  var body: some View {
    NavigationView {
      List {
        HStack {
          TextField("", text: $textField)
            .foregroundColor(fontColor)
            .font(.custom("FiraMono-Medium", size: 20))
            .tint(fontColor)
            .placeholder("new quote", when: textField.isEmpty, foregroundColor: fontColor)
            .background(backgroundColor)
            .padding(5)
            .onSubmit {
              addQuote()
            }
          Button {
            addQuote()
          } label: {
            Image(systemName: "plus")
              .foregroundColor(fontColor)
          }
        }
        .padding()
        .background(backgroundColor)
        .contentShape(Rectangle())
        .cornerRadius(10)
        .padding(.vertical, -2)
        .padding(.horizontal, -10)
        ForEach(items) { item in
          HStack {
            Text(item.title!)
              .font(.custom("FiraMono-Medium", size: 20))
              .padding(5)
              .foregroundColor(fontColor)
            Spacer()
          }
          .padding()
          .background(backgroundColor)
          .contentShape(Rectangle())
          .cornerRadius(10)
          .listRowSeparator(.hidden)
          .padding(.vertical, -2)
          .padding(.horizontal, -10)
        }
        .onDelete(perform: deleteItems)
        .onMove(perform: moveItems)
      }
      .listStyle(.plain)
      .id(UUID())
      .alert("🚨failed to add the quote!", isPresented: $alertIsPresented) {
        Button("ok", role: .cancel) {}
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
      .navigationTitle("my quotes")
      .environment(\.editMode, $editMode)
      .toolbar {
        editButton
      }
    }
  }
  
  private var editButton: some View {
    Button {
      withAnimation {
        switch editMode {
        case .inactive:
          editMode = .active
        default:
          editMode = .inactive
        }
      }
    } label: {
      Text(editMode.isEditing ? "done" : "edit")
    }
  }
  
  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      alertIsPresented.toggle()
    }
  }
  
  private func addQuote() {
    if !textField.isEmpty {
      let newQuote = Item(context: viewContext)
      newQuote.timestamp = Date()
      newQuote.title = textField
      addItem(newItem: newQuote)
      textField = ""
    }
  }
  
  private func moveItems(from source: IndexSet, to destination: Int) {
    // make an array of items from fetched results
    var revisedItems: [Item] = items.map { $0 }
    
    // change the order of the items in the array
    revisedItems.move(fromOffsets: source, toOffset: destination)
    
    // update the userOrder attribute in revisedItems to
    // persist the new order. This is done in reverse order
    // to minimize changes to the indices.
    for reverseIndex in stride(from: revisedItems.count - 1,
                               through: 0,
                               by: -1) {
      revisedItems[reverseIndex].userOrder = Int16(reverseIndex)
    }
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
