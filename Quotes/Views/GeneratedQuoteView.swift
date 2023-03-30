//
//  GeneratedQuoteView.swift
//  Quotes
//
//  Created by Sima Nerush on 3/24/23.
//

import SwiftUI

struct GeneratedQuoteView: View {
  @ObservedObject var model: QuoteModel
  
  private let quoteTypes: [String] = [
    "motivational", "inspirational", "eclectic", "esteemed", "spicy"
  ]
  
  @State private var selectedQuoteType = "motivational"
  @State private var output = ""
  @State private var isLoading = false
  
  @State private var alertIsPresented = false
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          Text("generate a")
          Picker("", selection: $selectedQuoteType) {
            ForEach(quoteTypes, id: \.self) {
              Text($0)
            }
          }
          Text("quote")
        }
        // for picker to stop truncating
        .padding(-20)
        Button {
          Task {
            await generateQuote()
            parseQuote()
          }
        } label: {
          Text("generate!⚡️")
        }
        .buttonStyle(.borderedProminent)
        .padding(10)
        if isLoading {
          ProgressView()
        } else if !output.isEmpty {
          QuoteTextField(model: model, text: $output, alertIsPresented: $alertIsPresented)
        }
      }
      
    }
    .alert("🚨failed to generate the quote!", isPresented: $alertIsPresented) {
      Button("ok", role: .cancel) {}
    }
    .navigationTitle("AI quote generator🤖")
  }
  
  private func parseQuote() {
    guard let openingQuoteIndex = output.firstIndex(of: "\""),
          let closingQuoteIndex = output.lastIndex(of: "\"") else {
      alertIsPresented = true
      return
    }
    
    let range = output.index(after: openingQuoteIndex)..<closingQuoteIndex
    output = String(output[range])
  }
  
  private func generateQuote() async {
    isLoading = true
    let result =
    await GPTCaller.shared.getResponse(
      input: "Give me a \(selectedQuoteType) quote")
    switch result {
    case .success(let output):
      self.output = output
      self.isLoading = false
    case .failure(let error):
      print("GPT error \(error)")
    }
  }
}

private struct QuoteTextField: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var model: QuoteModel
  
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = ChameleoUI.backgroundColor
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = ChameleoUI.textColor
  
  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.userOrder, ascending: true)
      ])
  private var items: FetchedResults<Item>
  
  @Binding var text: String
  @Binding var alertIsPresented: Bool
  
  var body: some View {
    HStack {
      Text(text)
        .font(ChameleoUI.listedQuoteFont)
        .padding(5)
        .foregroundColor(fontColor)
      Spacer()
      Button {
        addQuote()
      } label: {
        Image(systemSymbol: .plus)
          .foregroundColor(.white)
          .padding(8)
      }
    }
    .background(backgroundColor.gradient)
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    .padding(.horizontal, 20)
  }
  
  private func addQuote() {
    let newQuote = Item(context: viewContext)
    newQuote.timestamp = Date()
    newQuote.title = text
    addItem(newItem: newQuote)
    if items.isEmpty { model.setQuoteOfTheDay() }
  }
  
  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      alertIsPresented.toggle()
    }
  }
}
