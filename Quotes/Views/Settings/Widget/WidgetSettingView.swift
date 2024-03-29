//
//  WIdgetSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/19/23.
//

import SwiftUI

struct WidgetSettingView: View {

  @AppStorage("widgetUpdateFrequency", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var widgetUpdateFrequency = WidgetUpdateFrequency.daily

    var body: some View {
      Form {
        Picker("Frequency of widget updates", selection: $widgetUpdateFrequency) {
          ForEach(WidgetUpdateFrequency.allCases, id: \.self) { frequency in
            Text("\(frequency.stringValue().capitalized)").tag(frequency)
          }
        }
      }
    }
}
