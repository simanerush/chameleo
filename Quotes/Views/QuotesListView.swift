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
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("", text: $textField)
            .foregroundColor(fontColor)
            .font(.custom("FiraMono-Medium", size: 20))
            .tint(fontColor)
            .placeholder("new quote", when: textField.isEmpty, foregroundColor: fontColor)
            .background(backgroundColor)
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
              .foregroundColor(fontColor)
          }
        }
        .padding()
        .background(backgroundColor)
        .contentShape(Rectangle())
        .cornerRadius(10.0)
        .padding(.vertical, 2)
        .padding(.horizontal, 10)
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
            .cornerRadius(5.0)
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
        }
        Spacer()
      }
      .alert("🚨failed to add the quote!", isPresented: $alertIsPresented) {
        Button("ok", role: .cancel) {}
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
      .navigationTitle("my quotes")
    }
  }
  
  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      alertIsPresented.toggle()
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
