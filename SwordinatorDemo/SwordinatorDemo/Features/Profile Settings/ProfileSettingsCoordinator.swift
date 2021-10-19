//
//  ProfileSettingsCoordinator.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation
import UIKit
import Swordinator

class ProfileSettingsCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: Services
    
    enum Event {
        case close
    }
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        print("➡️ navigated to \(String(describing: Self.self))")
        
        let vm = ProfileSettingsViewModel(services: services)
        let vc = ProfileSettingsViewController(viewModel: vm)
        vc.coordinator = self
        self.navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .logout:
            logout()
        case .dismiss:
            dismiss()
        case .close:
            close()
        default:
            ()
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        } else {
            // handle here
        }
    }
}

// MARK: - Actions
extension ProfileSettingsCoordinator {
    private func logout() {
        parent?.handle(step: AppStep.logout)
    }
    
    private func dismiss() {
        parent?.handle(step: AppStep.profileSettingsCompleted)
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    private func close() {
        parent?.handle(step: AppStep.profileSettingsCompleted)
    }
}
