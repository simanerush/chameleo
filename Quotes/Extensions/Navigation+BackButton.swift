//
//  Navigation+BackButton.swift
//  Quotes
//
//  Created by Sima Nerush on 5/3/23.
//

import UIKit

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}
