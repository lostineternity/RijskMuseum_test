//
//  Router.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation
import UIKit

protocol Router {
    var context: UIViewController { get set}
    func push(to vc: UIViewController)
    func present(with vc: UIViewController)
}
