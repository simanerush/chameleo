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
  typealias Entry = SimpleEntry

  // Provides a timeline entry representing a placeholder version of the widget.
  func placeholder(in context: Context) -> SimpleEntry {
    return SimpleEntry(date: Date(), configuration: .init())
  }

  // Provides a timeline entry that represents the current time and state of a widget.
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
  }

  // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

struct QuotesWidgetEntryView : View {

  @ObservedObject var model: QuoteModel

  var entry: QuotesTimelineProvider.Entry

  var body: some View {
    Text(entry.date, style: .time)
      .foregroundColor(.red)
  }
}

@main
struct QuotesWidget: Widget {
  let kind: String = "QuotesWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "com.tanaschita.ExampleWidget",
      provider: QuotesTimelineProvider()) { entry in
        QuotesWidgetEntryView(model: QuoteModel(), entry: entry)
      }
      .configurationDisplayName("My Widget")
  }
}
