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

  let model: QuoteModel
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")

  init(model: QuoteModel) {
    self.model = model
  }

  // Provides a timeline entry representing a placeholder version of the widget.
  func placeholder(in context: Context) -> Entry {
    return Entry(date: Date(), title: "⏳quotes are loading")
  }

  // Provides a timeline entry that represents the current time and state of a widget.
  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date(), title: "⏳quotes are loading"))
  }

  // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let title: String = model.getTodayQuote()
    let entry = Entry(date: Date(), title: title)
    let timeline = Timeline(entries: [entry],
                            policy: .atEnd)
    completion(timeline)
  }
}

struct Entry: TimelineEntry {
  let date: Date
  let title: String
}

struct QuotesWidgetEntryView : View {

  var entry: QuotesTimelineProvider.Entry
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = Color(UIColor(red: 0.99, green: 0.80, blue: 0.43, alpha: 1.00))
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = .white
  
  var body: some View {
    ZStack {
      backgroundColor.ignoresSafeArea()
      Text(entry.title)
        .padding(5)
        .font(.custom("DelaGothicOne-Regular", size: 50))
        .foregroundColor(fontColor)
        .minimumScaleFactor(0.01)
    }
  }
}

@main
struct QuotesWidget: Widget {
  let kind: String = "QuotesWidget"

  let persistenceController = PersistenceController.shared
  let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "com.simanerush.Quotes.QuotesWidget",
      provider: QuotesTimelineProvider(model: QuoteModel(persistenceController: persistenceController))) { entry in
        QuotesWidgetEntryView(entry: entry)
      }
      .configurationDisplayName("quotes")
  }
}
