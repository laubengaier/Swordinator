//
//  NavCoordinator.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/19.
//

import Foundation
import MBProgressHUD
import Swordinator

protocol NavCoordinator: NavigationControllerCoordinator, ParentCoordinated, HasServices where Parent == Coordinator {}

// MARK: Task Actions
extension NavCoordinator {
    
    func navigateToTask(id: Int) {
        MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        services.lazyTask(id: id) { task in
            MBProgressHUD.hide(for: self.navigationController.view, animated: true)
            guard let task = task else { return }
            self.navigateToTask(task: task)
        }
    }
    
    func navigateToTask(task: Task) {
        let nvc = UINavigationController()
        let coordinator = TaskDetailCoordinator(navigationController: nvc, services: services, task: task)
        coordinator.parent = self
        navigationController.present(nvc, animated: true, completion: nil)
        childCoordinators.append(coordinator)
    }
    
    func endNavigateToTask(animated: Bool, shouldDismiss: Bool = false, completion: (() -> Void)? = nil) {
        parent?.handle(step: AppStep.taskDetailCompleted)
        if shouldDismiss {
            navigationController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func releaseTaskDetail() {
        releaseChild(type: TaskDetailCoordinator.self)
    }

}
