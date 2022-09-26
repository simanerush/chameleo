//
//  QuotesWidget.swift
//  QuotesWidget
//
//  Created by Sima Nerush on 9/8/22.
//

import WidgetKit
import SwiftUI
import Intents

struct QuotesTimelineProvider: TimelineProvider {

  // Provides a timeline entry representing a placeholder version of the widget.
  func placeholder(in context: Context) -> Entry {
    return Entry(date: Date(), title: "Loading")
  }

  // Provides a timeline entry that represents the current time and state of a widget.
  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date(), title: "Quote of the day"))
  }

  // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let entry = Entry(date: Date(), title: "test")
    let timeline = Timeline(entries: [entry],
                            policy: .after(Date.tomorrow))
    completion(timeline)
  }
}

struct Entry: TimelineEntry {
  let date: Date
  let title: String
}

struct QuotesWidgetEntryView : View {

  @ObservedObject var model: QuoteModel

  var entry: QuotesTimelineProvider.Entry

  var body: some View {
    Text(model.getTodayQuote())
  }
}

@main
struct QuotesWidget: Widget {
  let kind: String = "QuotesWidget"

  let persistenceController = PersistenceController.shared
  let model: QuoteModel
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")

  init() {
    // When the day changes, update the quote
    self.model = QuoteModel(persistenceController: persistenceController)
    if let storedQuote = UserDefaults.standard.array(forKey: "todaysQuote") {
      if storedQuote.first! as! Date != Date.today {
        model.computeRandomQuote()
      }
    } else if UserDefaults.standard.array(forKey: "todaysQuote") == nil {
       model.computeRandomQuote()
    }
  }

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "com.simanerush.Quotes.QuotesWidget",
      provider: QuotesTimelineProvider()) { entry in
        QuotesWidgetEntryView(model: model, entry: entry)
      }
      .configurationDisplayName("My Widget")
  }
}
