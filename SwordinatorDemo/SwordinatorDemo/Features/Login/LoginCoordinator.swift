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
    
    init(navigationController: UINavigationController, services: AppServices, step: AppStep) {
        self.navigationController = navigationController
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
        // handle steps
        guard let step = step as? AppStep else { return }
        switch step {
        case .auth:
            navigateToLogin()
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
    private func navigateToLogin() {
        let vm = LoginViewModel(services: services, coordinator: self)
        let vc = LoginViewController(viewModel: vm)
        navigationController.setViewControllers([
            vc
        ], animated: false)
    }
}
