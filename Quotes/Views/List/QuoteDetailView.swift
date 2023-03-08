//
//  QuoteDetailView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/23/23.
//

import SwiftUI
import SFSafeSymbols

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
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = AppColors.backgroundColor
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = AppColors.textColor
  
  @State private var alertIsPresented = false
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("📝edit this quote")
      HStack {
        TextField("edit the quote", text: Binding($item.title)!)
          .font(.custom("FiraMono-Medium", size: 20))
          .padding(5)
          .foregroundColor(fontColor)
          .onChange(of: item.title!) { _ in
            do {
              try viewContext.save()
            } catch {
              alertIsPresented.toggle()
            }
          }
        Spacer()
        ShareLink(item: item.title!) {
          Image(systemSymbol: .squareAndArrowUp)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20)
            .foregroundColor(.white)
        }
      }
      .padding()
      .background(backgroundColor)
      .contentShape(Rectangle())
      .cornerRadius(10)
      .padding(.vertical, -2)
      .padding(.horizontal, -10)
      Spacer()
    }
    .padding()
    .alert("🚨failed to edit the quote!", isPresented: $alertIsPresented) {
      Button("ok", role: .cancel) {}
    }
  }
}


