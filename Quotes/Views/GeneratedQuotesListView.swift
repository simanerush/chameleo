//
//  GeneratedQuotesListView.swift
//  Quotes
//
//  Created by Sima Nerush on 3/24/23.
//

import SwiftUI

struct GeneratedQuotesListView: View {
  private var quoteTypes: [String] = ["motivational", "inspirational", "eclectic", "esteemed", "spicy"]
  
  @State private var selectedQuoteType = "motivational"
  @State private var output = ""
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          Text("generate a")
          Picker("", selection: $selectedQuoteType) {
            ForEach(quoteTypes, id: \.self) {
              Text($0)
            }
          }
          Text("quote")
          
        }
        // for picker to stop truncating
        .padding(-20)
        Button {
          GPTCaller.shared.getResponse(input: "Give me a \(selectedQuoteType) quote") { result in
            switch result {
            case .success(let output):
              self.output = output
            case .failure:
              print("GPT error")
            }
          }
        } label: {
          Text("generate!⚡️")
        }
        .buttonStyle(.borderedProminent)
        .padding(10)
        Text(output)
      }
      
    }
    .navigationTitle("AI quote generator🤖")
  }
}
