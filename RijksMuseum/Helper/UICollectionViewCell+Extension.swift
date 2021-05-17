//
//  UICollectionViewCell+Extension.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    public static var identifier: String {
        return String(describing: self)
    }
}
