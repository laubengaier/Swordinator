//
//  SceneDelegate.swift
//  SwordinatorDemo
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/08.
//

import UIKit
import Swordinator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let appServices = AppServices()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            appCoordinator = AppCoordinator(window: window, services: appServices)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let url = URLContexts.first?.url,
            let deeplinkStep = AppDeeplinkStep.convert(url: url)
        else { return }
        appCoordinator?.handle(deepLink: deeplinkStep)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(userActivity)
    }
    
    func onUserNotification(didReceive response: UNNotificationResponse) {
        print("received pnp: \(response)")
    }
}
