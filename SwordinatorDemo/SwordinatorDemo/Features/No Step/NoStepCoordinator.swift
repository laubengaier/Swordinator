//
//  NoStepCoordinator.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation
import UIKit
import Swordinator

protocol NoStepCoordinatorHandling: AnyObject {
    func handle(event: NoStepCoordinator.Event)
}


class NoStepCoordinator: NavigationControllerCoordinator, AnyParentCoordinated
{
    enum Event {
        case something
        case something2
    }
    
    var parent: (Coordinator & NoStepCoordinatorHandling)?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    
    init(navigationController: UINavigationController, services: AppServices) {
        self.navigationController = navigationController
        self.services = services
        start()
    }
    
    func start() {
        let vc = NoStepViewController()
        vc.coordinator = self
        navigationController.setViewControllers([
            vc
        ], animated: false)
    }
}

// MARK: - NoStepViewControllerHandling
extension NoStepCoordinator: NoStepViewControllerHandling {
    func handle(event: NoStepViewController.Event) {
        switch event {
        case .noStepExample1:
            parent?.handle(event: .something)
        case .noStepExample2:
            parent?.handle(event: .something2)
        }
    }
}
