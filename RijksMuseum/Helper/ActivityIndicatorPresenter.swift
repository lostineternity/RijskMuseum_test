//
//  ActivityIndicatorPresenter.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation
import UIKit

protocol ActivityIndicatorPresenter {
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.activityIndicator.style = .large
            self.activityIndicator.color = .white
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
