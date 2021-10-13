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
    
    init(navigationController: UINavigationController, services: AppServices) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.services = services
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        print("➡️ navigated to \(String(describing: Self.self))")
        
        let vc = SyncViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .syncCompleted:
            parent?.handle(step: step)
        default:
            ()
        }
    }
    
}
