//
//  ProfileCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator
import MBProgressHUD

class ProfileCoordinator: NavCoordinator, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: Services
    
    init(navigationController: UINavigationController, services: Services, step: AppStep) {
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
        guard let step = step as? AppStep else { return }
        switch step {
        case .profile:
            navigateToProfile()
        case .profileSettings:
            showProfileSettings()
        case .profileSettingsCompleted:
            closeProfileSettings()
           
        case .taskDetailLazy(let id):
            navigateToTask(id: id)
        case .taskDetailCompleted:
            releaseTaskDetail()
            
        case .logout:
            logout()
            
        default:
            ()
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        guard let deepLink = deepLink as? AppDeeplinkStep else { return }
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        } else {
            switch deepLink
            {
            case .taskDetail(let task):
                navigateToTask(task: task)
            case .taskDetailLazy(let id):
                navigateToTask(id: id)
            case .profileSettings:
                showProfileSettings()
            default:
                ()
            }
        }
    }
}

// MARK: - Actions
extension ProfileCoordinator {
    
    private func navigateToProfile() {
        let vm = ProfileViewModel(services: services)
        let vc = ProfileViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    // MARK: Profile Settings
    private func showProfileSettings() {
        let nvc = UINavigationController()
        let coordinator = ProfileSettingsCoordinator(navigationController: nvc, services: services, step: .profileSettings)
        coordinator.parent = self
        navigationController.present(nvc, animated: true, completion: nil)
        childCoordinators.append(coordinator)
    }
    
    private func closeProfileSettings() {
        childCoordinators.removeAll { $0 is ProfileSettingsCoordinator }
    }
    
    // MARK: Others
    private func logout() {
        childCoordinators.removeAll { $0 is ProfileSettingsCoordinator }
        parent?.handle(step: AppStep.logout)
    }
    
    private func showAlert(title: String?, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigationController.present(alertVC, animated: true, completion: nil)
    }
}
