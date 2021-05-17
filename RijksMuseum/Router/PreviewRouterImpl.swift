//
//  PreviewRouterImpl.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/12/21.
//

import Foundation
import UIKit

enum PreviewRouteType {
    case openDetail(String)
}

protocol PreviewRouter {
    func perfomAction(with type: PreviewRouteType)
}

struct PreviewRouterImpl: Router {
    var context: UIViewController
    
    func present(with vc: UIViewController) {
        context.present(vc, animated: true, completion: nil)
    }
    
    func push(to vc: UIViewController) {
        context.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PreviewRouterImpl: PreviewRouter {
    func perfomAction(with type: PreviewRouteType) {
        switch type {
        case .openDetail(let itemId):
            let detailViewController = DetailViewController()
            detailViewController.viewModel = DetailViewModelImpl(with: itemId,
                                                                 networkService: DetailNetworkServiceImpl(requestService: RequestServiceImpl()))
            push(to: detailViewController)
        }
    }
}
