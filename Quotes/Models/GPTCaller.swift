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
  
  public func getResponse(input: String,
                          completion: @escaping (Result<String, Error>) -> Void) {
    client?.sendCompletion(with: input,
                           maxTokens: 50,
                           completionHandler: { result in
      switch result {
      case .success(let model):
        // here, model gives an array of choices!
        let output = model.choices.first!.text
        completion(.success(output))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }
}
