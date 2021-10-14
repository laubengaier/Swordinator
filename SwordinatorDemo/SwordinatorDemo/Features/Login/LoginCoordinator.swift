//
//  LoginCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class LoginCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    
    init(navigationController: UINavigationController, services: AppServices) {
        self.navigationController = navigationController
        self.services = services
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        let vm = LoginViewModel(services: services)
        let vc = LoginViewController(coordinator: self, viewModel: vm)
        navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    func handle(step: Step) {
        // handle steps
        guard let step = step as? AppStep else { return }
        switch step {
        case .authWithSIWA:
            print("🙋‍♂️ logged in with siwa")
            parent?.handle(step: AppStep.authCompleted)
        default:
            return
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        // login needs no deeplink handling
    }
}

// MARK: - Actions
extension LoginCoordinator {
    
}
