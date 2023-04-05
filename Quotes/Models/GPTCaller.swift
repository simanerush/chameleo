//
//  GPTCaller.swift
//  Quotes
//
//  Created by Sima Nerush on 3/24/23.
//

import Foundation
import OpenAISwift

final class GPTCaller {
  static let shared = GPTCaller()
  
  private var client: OpenAISwift?
  
  private init () {}
  
  public func setup() {
    self.client = OpenAISwift(authToken: Constants.key)
  }
  
  public func getResponse(input: String) async -> Result<String, Error> {
    do {
      let result = try await client!.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 50)
      return .success(result.choices!.first!.text)
    } catch {
      return .failure(error)
    }
  }
}
