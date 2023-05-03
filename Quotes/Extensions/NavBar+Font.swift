//
//  NavBar+Font.swift
//  Quotes
//
//  Created by Sima Nerush on 5/3/23.
//

import SwiftUI

private struct ChameleoNavBar: ViewModifier {
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.font: ChameleoUI.navigationFont]
  }

  func body(content: Content) -> some View {
    content
  }
}

extension View {
  func chameleoNavBar() -> some View {
    self.modifier(ChameleoNavBar())
  }
}
