//
//  QuotesListView.swift
//  Quotes
//
//  Created by Sima Nerush on 9/2/22.
//

import SwiftUI
import CoreData
import SwipeActions

struct QuotesListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  @ObservedObject var model: QuoteModel
  @ObservedObject private var subscriptionModel = SubscriptionModel.shared

  @State private var textField = ""
  @State private var alertIsPresented = false

  @State private var paywallIsPresented = false

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
      ],
    animation: .default)
  private var items: FetchedResults<Item>

  @FocusState private var isFocusedInEditing: Bool

  var body: some View {
    NavigationView {
      List {
        newQuoteTextEditor
          .padding()
          .background(backgroundColor.gradient)
          .contentShape(Rectangle())
          .cornerRadius(10)
          .shadow(color: .gray.opacity(0.6), radius: 3.0, x: 0, y: 0)
        ForEach(items) { item in
          SwipeView {
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
              .shadow(color: .gray.opacity(0.6), radius: 3.0, x: 0, y: 0)

              NavigationLink(destination: QuoteDetailView(model: model, item: item)
                .navigationBarTitleDisplayMode(.inline)) {
                EmptyView()
              }
              .opacity(0)
            }
          } trailingActions: { _ in
            SwipeAction {
              viewContext.delete(item)
              do {
                try viewContext.save()
              } catch {
                alertIsPresented.toggle()
              }
              model.setQuoteOfTheDay()
            } label: { _ in
              Text("Delete")
                .bold()
                .foregroundColor(.white)
            } background: { _ in
              Color.red
            }
            .allowSwipeToTrigger()
          }
          .swipeActionCornerRadius(10)
          .swipeActionsMaskCornerRadius(0)
        }
        .listRowSeparator(.hidden)
      }
      .listStyle(.plain)
      .scrollIndicators(.hidden)
      .alert("🚨Failed to add the quote!", isPresented: $alertIsPresented) {
        Button("ok", role: .cancel) {}
      }
      .defaultAppStorage(UserDefaults(suiteName: "group.com.simanerush.Quotes")!)
      .navigationTitle("My quotes")
      .chameleoNavBar()
      .sheet(isPresented: $paywallIsPresented, content: {
          PaywallView(isPresented: $paywallIsPresented)
      })
    }
  }

  private var newQuoteTextEditor: some View {
    HStack {
      TextEditor(text: $textField)
        .scrollContentBackground(.hidden)
        .foregroundColor(fontColor)
        .font(ChameleoUI.listedQuoteFont)
        .tint(fontColor)
        .placeholder("New quote... ", when: textField.isEmpty && !isFocusedInEditing, foregroundColor: fontColor)
        .onSubmit {
          addQuote()
        }
        .focused($isFocusedInEditing, equals: true)
        .onTapGesture {
          isFocusedInEditing.toggle()
        }
      if !textField.isEmpty {
        Button {
          if items.count < 10 || subscriptionModel.subscriptionActive {
            addQuote()
          } else {
            paywallIsPresented = true
          }
        } label: {
          Image(systemSymbol: .plus)
            .foregroundColor(fontColor)
        }
      }
    }
    .listRowSeparator(.hidden)
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
      newQuote.title = textField.trimmingCharacters(in: .whitespacesAndNewlines)
      newQuote.author = ""
      addItem(newItem: newQuote)
      textField = ""
      if isTheFirstEntry { model.setQuoteOfTheDay() }
    }
  }
}
