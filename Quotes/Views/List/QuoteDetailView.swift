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
  @Environment(\.presentationMode) private var presentationMode

  @EnvironmentObject var context: NavigationContext

  @ObservedObject var model: QuoteModel

  @FetchRequest(
    sortDescriptors:
      [
        NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
      ],
    animation: .default)

  private var items: FetchedResults<Item>

  @ObservedObject var item: Item

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  @State private var alertIsPresented = false
  @State var makeQuoteOfTheDayButtonTapped = false

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if let title = Binding($item.title) {
          TextField("", text: title, axis: .vertical)
            .lineLimit(item.title!.count)
            .foregroundColor(fontColor)
            .font(ChameleoUI.listedQuoteFont)
            .tint(fontColor)
            .onChange(of: item.title!) { _ in
              do {
                try viewContext.save()
              } catch {
                alertIsPresented.toggle()
              }
            }
        }
        Spacer()
        shareButton
      }
      .padding()
      .background(backgroundColor.gradient)
      .contentShape(Rectangle())
      .cornerRadius(10)
      byAuthorTextField
      makeTodayQuoteButton
      Spacer()
    }
    .padding()
    .alert("🚨Failed to edit the quote!", isPresented: $alertIsPresented) {
      Button("Ok", role: .cancel) {}
    }
    .onChange(of: context.navToHome) { _ in
      presentationMode.wrappedValue.dismiss()
    }
  }

  var makeTodayQuoteButton: some View {
    Button {
      model.makeTodayQuote(item: item)
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
      withAnimation {
        makeQuoteOfTheDayButtonTapped = true
      }
    } label: {
      HStack {
        Text("Make it quote of the day💭")
          .bold()
          .foregroundColor(backgroundColor)
        Spacer()
      }
    }
    .buttonStyle(.bordered)
    .tint(backgroundColor)
    .opacity(makeQuoteOfTheDayButtonTapped ? 0 : 1)
  }

  var byAuthorTextField: some View {
    HStack {
      Text("by")
        .font(.headline)
        .foregroundColor(backgroundColor)
      TextField(text: Binding($item.author)!, label: {
        Text("name of the author")
      })
      .textFieldStyle(.roundedBorder)
      .onChange(of: item.author!) { _ in
        do {
          try viewContext.save()
        } catch {
          alertIsPresented.toggle()
        }
      }
    }
  }

  var shareButton: some View {
    ShareLink(item: item.title ?? "No title") {
      Image(systemSymbol: .squareAndArrowUp)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 20)
        .foregroundColor(.white)
    }
  }
}
