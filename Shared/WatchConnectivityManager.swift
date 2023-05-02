//
//  WatchConnectivityManager.swift
//  Quotes
//
//  Created by Sima Nerush on 3/19/23.
//

import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate {
  let quoteSubject: PassthroughSubject<String, Never>

  init(quoteSubject: PassthroughSubject<String, Never>) {
    self.quoteSubject = quoteSubject
    super.init()
  }

  func session(_ session: WCSession,
               activationDidCompleteWith activationState: WCSessionActivationState,
               error: Error?) { }

  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    DispatchQueue.main.async {
      if let quote = message["quote"] as? String {
        self.quoteSubject.send(quote)
      } else {
        fatalError("cannot send the watchconnectivity subject!")
      }
    }
  }

#if os(iOS)
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("\(#function): activationState = \(session.activationState.rawValue)")
  }

  func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }

  func sessionWatchStateDidChange(_ session: WCSession) {
    print("\(#function): activationState = \(session.activationState.rawValue)")
  }
#endif
}
