//
//  GeneratedQuoteView.swift
//  Quotes
//
//  Created by Sima Nerush on 3/24/23.
//
import SwiftUI

struct GeneratedQuoteView: View {
  @ObservedObject var model: QuoteModel

  @State private var selectedQuoteType: QuoteType?
  @State private var quoteOutput = ""
  @State private var authorOutput = ""
  @State private var isLoading = false
  @State private var didGenerateOnce = false

  @State private var alertIsPresented = false

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        Text("Use AI to expand your quote collection")
          .font(.system(.title2, weight: .bold))
          .bold()
          .padding(.bottom, 30)
        HStack {
          Text("Get a")
            .bold()
          ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
              .fill(Color(.systemGray6))
              .frame(height: 30)
            Picker("quote type", selection: $selectedQuoteType) {
              if !didGenerateOnce {
                Text("choose a quote type").tag(nil as QuoteType?)
                  .foregroundColor(selectedQuoteType == nil ? .gray : .primary)
              }
              ForEach(QuoteType.allCases, id: \.self) { quoteType in
                Text(quoteType.rawValue)
                  .tag(quoteType as QuoteType?)
              }
            }
            .onChange(of: selectedQuoteType) { quoteType in
              guard let quoteType else { return }
              Task {
                isLoading = true
                await displayGeneratedQuote(withType: quoteType)
                isLoading = false
                didGenerateOnce = true
              }
            }
          }
          Text("quote")
            .bold()
        }
        if isLoading {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
        } else if !quoteOutput.isEmpty {
          VStack {
            QuoteTextField(model: model,
                           text: $quoteOutput,
                           author: $authorOutput,
                           alertIsPresented: $alertIsPresented)
          }
        }
        Spacer()
      }
      .padding(15)
      .navigationTitle("Chameleo AI")
      .chameleoNavBar()
    }
    .alert("🚨Failed to get the quote!", isPresented: $alertIsPresented) {
      Button("Ok", role: .cancel) {}
    }
  }

  private func displayGeneratedQuote(withType type: QuoteType) async {
    await generateQuote(ofType: type.rawValue)
    parseQuote()
  }

  private func parseQuote() {
    guard let openingQuoteIndex = quoteOutput.firstIndex(of: "\""),
          let closingQuoteIndex = quoteOutput.lastIndex(of: "\"")
    else {
      alertIsPresented = true
      return
    }

    if let authorIndex = quoteOutput.firstIndex(of: "-") {
      let authorRange = quoteOutput.index(after: authorIndex)..<quoteOutput.endIndex
      authorOutput = String(quoteOutput[authorRange])
    }

    let quoteRange = quoteOutput.index(after: openingQuoteIndex)..<closingQuoteIndex
    quoteOutput = String(quoteOutput[quoteRange])
  }

  private func generateQuote(ofType type: String) async {
    isLoading = true
    let result =
    await GPTCaller.shared.getResponse(
      input: "Give me a \(type) quote")
    switch result {
    case .success(let output):
      self.quoteOutput = output
      self.isLoading = false
    case .failure(let error):
      print("GPT error \(error)")
    }
  }
}

private struct QuoteTextField: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var model: QuoteModel

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
      ])
  private var items: FetchedResults<Item>

  @Binding var text: String
  @Binding var author: String
  @Binding var alertIsPresented: Bool

  @State var didAddQuote = false

  var body: some View {
    VStack {
      HStack {
        Text(text)
          .font(ChameleoUI.listedQuoteFont)
          .padding(15)
          .foregroundColor(fontColor)
        Spacer()
        if didAddQuote && items.count != 0 {
          withAnimation {
            Image(systemSymbol: .checkmark)
              .foregroundColor(.white)
              .padding(8)
          }

        } else {
          Button {
            addQuote()
          } label: {
            Image(systemSymbol: .plus)
              .foregroundColor(.white)
              .padding(8)
          }
        }
      }
      .background(backgroundColor.gradient)
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
      .shadow(color: .gray.opacity(0.6), radius: 3.0, x: 0, y: 0)

      if !author.isEmpty {
        authorView
      }
    }
  }

  private var authorView: some View {
    HStack {
      Text("— \(author)")
        .font(Font.system(.body, design: .rounded, weight: .regular))
        .padding(8)
      Spacer()
    }
    .background(Color.gray.gradient.opacity(0.3))
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
  }

  private func addQuote() {
      var isTheFirstEntry = false
      if items.isEmpty {
        isTheFirstEntry = true
      }
      let newQuote = Item(context: viewContext)
      newQuote.timestamp = Date()
      newQuote.title = text
      newQuote.author = author
      addItem(newItem: newQuote)
      if isTheFirstEntry { model.setQuoteOfTheDay() }
      didAddQuote = true
      success()
  }

  private func success() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
  }

  private func addItem(newItem: Item) {
    do {
      try viewContext.save()
    } catch {
      alertIsPresented.toggle()
    }
  }
}

struct GeneratedQuoteView_Previews: PreviewProvider {
  static var previews: some View {
    GeneratedQuoteView(model: QuoteModel.shared)
      .accentColor(ChameleoUI.backgroundColor)
  }
}
