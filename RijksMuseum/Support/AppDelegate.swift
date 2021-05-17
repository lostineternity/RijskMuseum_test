//
//  AppDelegate.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/10/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            // handling by SceneDelefate
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            let viewController = PreviewCollectionViewController()
            viewController.viewModel = PreviewViewModelImpl(with: PreviewNetworkServiceImpl(requestService: RequestServiceImpl()),
                                                               router: PreviewRouterImpl(context: viewController))
            window?.rootViewController = UINavigationController(rootViewController: viewController)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

