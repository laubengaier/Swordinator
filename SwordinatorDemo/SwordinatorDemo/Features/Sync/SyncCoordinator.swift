//
//  SyncCoordinator.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/13.
//

import Foundation
import Swordinator
import UIKit

class SyncCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable {
    
    var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    
    init(navigationController: UINavigationController, services: AppServices, step: AppStep) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.services = services
        start(step: step)
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start(step: Step) {
        print("⬇️ Navigated to \(String(describing: Self.self))")
        handle(step: step)
    }
    
    func handle(step: Step) {
        print("  ➡️ \(String(describing: Self.self)) -> \(step)")
        guard let step = step as? AppStep else { return }
        switch step {
        case .sync:
            navigateToSync()
        case .syncCompleted:
            parent?.handle(step: step)
        default:
            ()
        }
    }
}

// MARK: - Actions
extension SyncCoordinator {
    func navigateToSync() {
        let vc = SyncViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
}
