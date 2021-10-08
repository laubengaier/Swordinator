//
//  ProfileCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

protocol ProfileCoordinatorHandling: AnyObject
{
    func handle(event: ProfileCoordinator.Event)
}

class ProfileCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: ProfileCoordinatorHandling?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    
    enum Event {
        case close
        case logout
    }
    
    init(navigationController: UINavigationController, services: AppServices) {
        self.navigationController = navigationController
        self.services = services
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        print("➡️ navigated to \(String(describing: Self.self))")
        
        let vm = ProfileViewModel(services: services)
        let vc = ProfileViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .close:
            childCoordinators.removeAll { $0 is TaskDetailCoordinator }
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
                self.showTaskDetail(task: task)
            default:
                ()
            }
        }
    }
    
    func showTaskDetail(task: Task) {
        let nvc = UINavigationController()
        let coordinator = TaskDetailCoordinator(navigationController: nvc, services: services, task: task)
        coordinator.parent = self
        navigationController.present(nvc, animated: true, completion: nil)
        childCoordinators.append(coordinator)
    }
}

extension ProfileCoordinator: ProfileViewControllerHandling {
    func handle(event: ProfileViewController.Event) {
        switch event {
        case .logout:
            parent?.handle(event: .logout)
        }
    }
}
