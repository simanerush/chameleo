//
//  View+Placeholder.swift
//  Quotes
//
//  Created by Sima Nerush on 12/1/22.
//

import SwiftUI

extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
  
  func placeholder(
    _ text: String,
    when shouldShow: Bool,
    foregroundColor: Color) -> some View {
      
      placeholder(when: shouldShow, alignment: .leading) { Text(text).font(.custom("FiraMono-Medium", size: 20)).foregroundColor(foregroundColor).opacity(0.5) }
    }
}
