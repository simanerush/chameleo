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
  
  @ObservedObject var model: QuoteModel
  
  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
      ],
    animation: .default)
  
  private var items: FetchedResults<Item>
  
  @ObservedObject var item: Item
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  
  @State private var alertIsPresented = false
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("edit the quote", text: Binding($item.title)!)
          .font(ChameleoUI.listedQuoteFont)
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
      .background(backgroundColor.gradient)
      .contentShape(Rectangle())
      .cornerRadius(10)
      Button {
        model.makeTodayQuote(item: item)
      } label: {
        HStack {
          Text("💭 make quote of the day")
            .bold()
          Spacer()
        }
      }
      .buttonStyle(.bordered)
      .tint(ChameleoUI.backgroundColor)
      Spacer()
    }
    .padding()
    .alert("🚨failed to edit the quote!", isPresented: $alertIsPresented) {
      Button("ok", role: .cancel) {}
    }
  }
}


