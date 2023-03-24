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
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  
  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.userOrder, ascending: true)
      ],
    animation: .default)
  private var items: FetchedResults<Item>
  
  @FocusState private var isFocusedInEditing: Bool
  
  var body: some View {
    NavigationView {
      List {
        newQuoteTextField
        .padding()
        .background(backgroundColor.gradient)
        .contentShape(Rectangle())
        .cornerRadius(10)
        .padding(.vertical, -2)
        .padding(.horizontal, -10)
        ForEach(items) { item in
          QuoteListCell(model: model, item: item)
          .listRowSeparator(.hidden)
        }
        .onDelete(perform: deleteItems)
        .onMove(perform: moveItems)
      }
      .listStyle(.plain)
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
  
  private var newQuoteTextField: some View {
    HStack {
      TextEditor(text: $textField)
        .foregroundColor(fontColor)
        .font(ChameleoUI.listedQuoteFont)
        .tint(fontColor)
        .placeholder("new quote ", when: textField.isEmpty, foregroundColor: fontColor)
        .onSubmit {
          addQuote()
        }
        .focused($isFocusedInEditing, equals: true)
        .onTapGesture {
          isFocusedInEditing.toggle()
        }
      Button {
        addQuote()
      } label: {
        Image(systemSymbol: .plus)
          .foregroundColor(fontColor)
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
      var isTheFirstEntry = false
      if items.isEmpty {
        isTheFirstEntry = true
      }
      let newQuote = Item(context: viewContext)
      newQuote.timestamp = Date()
      newQuote.title = textField
      addItem(newItem: newQuote)
      textField = ""
      if isTheFirstEntry { model.setQuoteOfTheDay() }
    }
  }
  
  private func moveItems(from source: IndexSet, to destination: Int) {
    withAnimation {
      var revisedItems: [Item] = items.map { $0 }
      revisedItems.move(fromOffsets: source, toOffset: destination)
      
      for reverseIndex in stride(from: revisedItems.count - 1,
                                 through: 0,
                                 by: -1) {
        revisedItems[reverseIndex].userOrder = Int16(reverseIndex)
      }
      
      do {
        try viewContext.save()
      } catch {
        alertIsPresented.toggle()
      }
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        alertIsPresented.toggle()
      }
    }
    model.setQuoteOfTheDay()
  }
}

struct QuoteListCell: View {
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  @ObservedObject var model: QuoteModel
  
  var item: Item
  
  var body: some View {
    ZStack {
      HStack {
        Text(item.title! + " ")
          .font(ChameleoUI.listedQuoteFont)
          .padding(5)
          .foregroundColor(fontColor)
        Spacer()
      }
      .padding()
      .background(backgroundColor.gradient)
      .contentShape(Rectangle())
      .cornerRadius(10)
      .padding(.vertical, -2)
      .padding(.horizontal, -10)
      
      NavigationLink(destination: QuoteDetailView(model: model, item: item).navigationBarTitleDisplayMode(.inline)) {
        EmptyView()
      }
      .opacity(0)
    }
  }
}
