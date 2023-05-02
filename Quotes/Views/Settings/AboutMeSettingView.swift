//
//  AboutMeSettingView.swift
//  Quotes
//
//  Created by Sima Nerush on 5/1/23.
//

import SwiftUI

struct AboutMeSettingView: View {
  @EnvironmentObject var context: NavigationContext
  @Environment(\.presentationMode) private var presentationMode

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      .onChange(of: context.navToHome) { _ in
        presentationMode.wrappedValue.dismiss()
      }
  }
}

struct AboutMeSettingView_Previews: PreviewProvider {
  static var previews: some View {
    AboutMeSettingView()
  }
}
