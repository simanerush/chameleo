//
//  QuoteDetailView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/23/23.
//

import SwiftUI

struct QuoteDetailView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
      ],
    animation: .default)
  private var items: FetchedResults<Item>
  
  @ObservedObject var item: Item
  
  @State private var alertIsPresented = false
  
  var body: some View {
    TextField("edit the quote", text: Binding($item.title)!)
      .onChange(of: item.title!) { _ in
        do {
          try viewContext.save()
        } catch {
          alertIsPresented.toggle()
        }
      }
      .alert("🚨failed to edit the quote!", isPresented: $alertIsPresented) {
        Button("ok", role: .cancel) {}
      }
  }
}
