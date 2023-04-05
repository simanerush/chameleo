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
  @State private var isLoading = false
  
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
          Task {
            isLoading = true
            let result =
            await GPTCaller.shared.getResponse(
              input: "Give me a \(selectedQuoteType) quote")
            switch result {
            case .success(let output):
              self.output = output
              self.isLoading = false
            case .failure(let error):
              print("GPT error \(error)")
            }
          }
        } label: {
          Text("generate!⚡️")
        }
        .buttonStyle(.borderedProminent)
        .padding(10)
        if isLoading {
          ProgressView()
        } else {
          Text(output)
        }
      }
      
    }
    .navigationTitle("AI quote generator🤖")
  }
}
