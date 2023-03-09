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
  
  @AppStorage("widgetUpdateFrequency", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var widgetUpdateFrequency = WidgetUpdateFrequency.daily
  
  let model: QuoteModel
  
  init(model: QuoteModel) {
    self.model = model
  }
  
  func placeholder(in context: Context) -> Entry {
    return Entry(date: Date(), title: "⏳quotes are loading")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date(), title: "⏳quotes are loading"))
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let title: String = model.quoteOfTheDay
    // we know that the quote's date must be today
    let creationDate = Date()
    // schedule the next update to next day depending on user's preference
    let nextUpdate = Calendar
      .autoupdatingCurrent
      .date(byAdding: widgetUpdateFrequency == .daily ? .day : .hour,
            value: 1,
            to: Calendar.autoupdatingCurrent.startOfDay(for: creationDate))!
    
    let entry = Entry(date: creationDate, title: title)
    let timeline = Timeline(entries: [entry],
                            policy: .after(nextUpdate))
    completion(timeline)
  }
}

struct Entry: TimelineEntry {
  let date: Date
  let title: String
}

struct QuotesWidgetEntryView: View {
  
  var entry: QuotesTimelineProvider.Entry
  @AppStorage("backgroundColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var backgroundColor = AppColors.backgroundColor
  
  @AppStorage("fontColor", store: UserDefaults(suiteName: "group.com.simanerush.Quotes")) private var fontColor: Color = AppColors.textColor
  
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
  
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "com.simanerush.Quotes.QuotesWidget",
      provider: QuotesTimelineProvider(model: QuoteModel(persistenceController: persistenceController))) { entry in
        QuotesWidgetEntryView(entry: entry)
      }
      .configurationDisplayName("quotes")
  }
}
