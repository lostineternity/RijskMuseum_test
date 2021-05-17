//
//  UIView+Extension.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation
import UIKit

extension UIView {
    func makeZeroConstraints(to superView: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        ])
    }
    
    func makeZeroConstraints(to superView: UILayoutGuide) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        ])
    }
}
