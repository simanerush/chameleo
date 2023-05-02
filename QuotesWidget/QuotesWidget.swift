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

  @AppStorage("widgetUpdateFrequency", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var widgetUpdateFrequency = WidgetUpdateFrequency.daily

  func placeholder(in context: Context) -> Entry {
    return Entry(date: Date(), title: "Quotes are loading⏳")
  }

  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    completion(Entry(date: Date(), title: "Quotes are loading⏳"))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var title: String? = "You don't have any quotes!"
    let defaults = UserDefaults(suiteName: "group.com.simanerush.Quotes")!
    if let storedQuotes = defaults.array(forKey: "todaysQuote") {
      title = storedQuotes[1] as? String
    }
    // we know that the quote's date must be today
    let creationDate = Date()
    // schedule the next update to next day depending on user's preference
    let nextUpdate = Calendar
      .autoupdatingCurrent
      .date(byAdding: widgetUpdateFrequency == .daily ? .day : .hour,
            value: 1,
            to: Calendar.autoupdatingCurrent.startOfDay(for: creationDate))!

    guard let title else { fatalError("could not convert title to string") }
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
  @Environment(\.widgetFamily) var family

  var entry: QuotesTimelineProvider.Entry

  var body: some View {
    #warning("Widgets should look slightly different for each size because of the gradient")
    switch family {
    case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
      HomeScreenWidgetView(entry: entry)
    case .accessoryRectangular:
      Text(entry.title)
        .font(ChameleoUI.listedQuoteFont)
        .minimumScaleFactor(0.01)
    case .accessoryInline:
      Text(entry.title)
        .bold()
    case .accessoryCircular:
      ZStack {
        Color.white.opacity(0.1)
        Image("ashotik")
          .resizable()
          .scaledToFit()
      }
    default:
      EmptyView()
    }
  }
}

struct HomeScreenWidgetView: View {
  @Environment(\.colorScheme) var colorScheme

  var entry: QuotesTimelineProvider.Entry

  @AppStorage("backgroundColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var backgroundColor = ChameleoUI.backgroundColor

  @AppStorage("fontColor", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var fontColor: Color = ChameleoUI.textColor

  var body: some View {
    ZStack {
      RadialGradient(gradient:
                      Gradient(colors: [backgroundColor, colorScheme == .dark ? .black : .white]),
                     center: .center, startRadius: 2, endRadius: 220).ignoresSafeArea()
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

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "com.simanerush.Quotes.QuotesWidget",
      provider: QuotesTimelineProvider()) { entry in
        QuotesWidgetEntryView(entry: entry)
      }
      .configurationDisplayName("Quote of the day💭")
      .supportedFamilies(
        [
          .systemSmall,
          .systemMedium,
          .systemLarge,
          .systemExtraLarge,
          .accessoryInline,
          .accessoryCircular,
          .accessoryRectangular
        ]
      )
  }
}
