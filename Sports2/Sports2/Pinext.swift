//
//  Pinext.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation
import UIKit

public extension UIView {
    func pin(to view: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }
}
