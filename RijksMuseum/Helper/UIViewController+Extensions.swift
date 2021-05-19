//
//  UIViewController+Extensions.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/13/21.
//

import Foundation

import UIKit

extension UIViewController {
    public typealias AlertCompletionHandler = (()->())?
    public func showErrorAlert(with title: String = "Attention!",
                               message: String,
                               actionHandler: AlertCompletionHandler = nil) {
        let errorAlert = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok",
                                           style: .default,
                                           handler: { _ in actionHandler?()}))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
}
