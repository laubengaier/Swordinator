//
//  TaskListCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class TaskListCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable
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
        print("➡️ navigated to \(String(describing: Self.self))")
        
        let vm = TaskListViewModel(services: services)
        let vc = TaskListViewController(viewModel: vm)
        vc.coordinator = self
        self.navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .taskDetail(let task):
            showTaskDetail(task: task)
        case .logout:
            parent?.handle(step: step)
        case .close:
            childCoordinators.removeAll { $0 is TaskDetailCoordinator }
        default:
            ()
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        } else {
            guard let deepLink = deepLink as? AppDeeplinkStep else { return }
            switch deepLink {
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
