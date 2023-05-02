//
//  WIdgetSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 1/19/23.
//

import SwiftUI

struct WidgetSettingView: View {
  @EnvironmentObject var context: NavigationContext
  @Environment(\.presentationMode) private var presentationMode

  @AppStorage("widgetUpdateFrequency", store:
                UserDefaults(suiteName: "group.com.simanerush.Quotes"))
  private var widgetUpdateFrequency = WidgetUpdateFrequency.daily

    var body: some View {
      Form {
        Picker("frequency of widget updates", selection: $widgetUpdateFrequency) {
          ForEach(WidgetUpdateFrequency.allCases, id: \.self) { frequency in
            Text("\(frequency.stringValue())").tag(frequency)
          }
        }
      }
      .onChange(of: context.navToHome) { _ in
        presentationMode.wrappedValue.dismiss()
      }
    }
}
