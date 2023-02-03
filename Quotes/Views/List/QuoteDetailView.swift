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
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  @State private var alertIsPresented = false
  
  var body: some View {
    VStack {
      TextField("edit the quote", text: Binding($item.title)!)
        .onChange(of: item.title!) { _ in
          do {
            try viewContext.save()
          } catch {
            alertIsPresented.toggle()
          }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    .alert("🚨failed to edit the quote!", isPresented: $alertIsPresented) {
      Button("ok", role: .cancel) {}
    }
  }
}
