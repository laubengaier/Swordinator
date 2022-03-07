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
    
    init(window: UIWindow, services: AppServices, step: AppStep) {
        self.window = window
        self.services = services
        start(step: step)
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    // no matter what step is triggered from AppDelegate it's overriden here
    // otherwise just call the step handler
    func start(step: Step) {
        print("⬇️ Navigated to \(String(describing: Self.self))")
        if services.isAuthenticated {
            services.isSyncRequired ? handle(step: AppStep.sync) : handle(step: AppStep.dashboard)
        } else {
            handle(step: AppStep.auth)
        }
    }
    
    func handle(step: Step) {
        print("  ➡️ \(String(describing: Self.self)) -> \(step)")
        guard let step = step as? AppStep else { return }
        switch step {
            
        case .dashboard:
            return showTabbar()
        case .auth:
            showLogin()
        case .sync:
            showSync()
            
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

// MARK: - Actions
extension AppCoordinator {
    private func showTabbar() {
        let tbc = UITabBarController()
        let coordinator = DashboardCoordinator(tabBarController: tbc, services: services, step: .dashboard)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = tbc
    }
    
    private func showLogin() {
        let nvc = UINavigationController()
        let coordinator = LoginCoordinator(navigationController: nvc, services: services, step: .auth)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = nvc
    }
    
    private func showSync() {
        let nvc = UINavigationController()
        let coordinator = SyncCoordinator(navigationController: nvc, services: services, step: .sync)
        coordinator.parent = self
        rootCoordinator = coordinator
        window.rootViewController = nvc
    }
}
