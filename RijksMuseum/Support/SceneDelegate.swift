//
//  SceneDelegate.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.makeKeyAndVisible()
            self.window = window

            let viewController = PreviewCollectionViewController()
            viewController.viewModel = PreviewViewModelImpl(with: PreviewNetworkServiceImpl(requestService: RequestServiceImpl()),
                                                            router: PreviewRouterImpl(context: viewController))
            window.rootViewController = UINavigationController(rootViewController: viewController)
        }
    }
}

