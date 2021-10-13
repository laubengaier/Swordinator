//
//  AppCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class AppCoordinator: Coordinator, Deeplinkable {
    
    let window: UIWindow
    let services: AppServices
    var rootCoordinator: (Coordinator & Deeplinkable)?
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow, services: AppServices) {
        self.window = window
        self.services = services
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        if services.isAuthenticated {
            services.isSyncRequired ? showSync() : showTabbar()
        } else {
            self.showLogin()
        }
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .logout:
            showLogin()
        case .authCompleted:
            services.isSyncRequired ? showSync() : showTabbar()
        case .syncCompleted:
            showTabbar()
        default:
            return
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        if let deepLink = deepLink as? AppDeeplinkStep {
            switch deepLink
            {
            case .logout:
                showLogin()
                return
            default:
                ()
            }
        }
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        }
    }
}

extension AppCoordinator {
    private func showTabbar() {
        let tbc = UITabBarController()
        let coordinator = DashboardCoordinator(tabBarController: tbc, services: services)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = tbc
    }
    
    private func showLogin() {
        let nvc = UINavigationController()
        let coordinator = LoginCoordinator(navigationController: nvc, services: services)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = nvc
    }
    
    private func showSync() {
        let nvc = UINavigationController()
        let coordinator = SyncCoordinator(navigationController: nvc, services: services)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = nvc
    }
}
