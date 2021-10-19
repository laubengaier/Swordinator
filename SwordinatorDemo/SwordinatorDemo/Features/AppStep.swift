//
//  AppStep.swift
//  SimpleCoordinatorDemo
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/08.
//

import Foundation
import Swordinator
import UIKit
import MBProgressHUD

enum AppStep: Step {
    
    // task
    case taskDetail(task: Task, completion: (() -> Void)?)
    case taskDetailLazy(id: Int)
    case taskDetailReminder(task: Task)
    case taskDetailPriority(task: Task)
    case taskDetailCompleted
    
    // auth
    case authWithSIWA
    case authCompleted
    case logout
    
    // sync
    case sync
    case syncCompleted
    
    // profile
    case profile
    case profileSettings
    case closeProfileSettings
    
    // navigation
    case close
    case closeChildren
    case dismiss
    case pop
}

enum AppDeeplinkStep: DeeplinkStep {
    
    // task
    case taskDetail(task: Task)
    case taskDetailLazy(id: Int)
    
    // tabbar
    case tasks
    case profile
    
    // profile
    case profileSettings
    case logout
    
}

extension AppDeeplinkStep {
    static func convert(url: URL) -> AppDeeplinkStep? {
        guard
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        guard
            let host = components.host,
            let path = components.path
            //let params = components.queryItems
        else {
            return nil
        }
        print("host = \(host)")
        print("path = \(path)")
        
        if url.absoluteString.starts(with: "swordinator://newTask") {
            return .taskDetail(task: Task(id: 10, name: "Test1"))
        } else if host == "tasks", let path = Int(url.pathComponents[1]) {
            return .taskDetailLazy(id: path)
        } else if host == "tasks" {
            return .tasks
        } else if host == "profile" {
            return .profile
        } else if host == "logout" {
            return .logout
        } else if host == "settings" {
            return .profileSettings
        }
        return nil
    }
}



protocol NavCoordinator: NavigationControllerCoordinator, ParentCoordinated, HasServices where Parent == Coordinator {}

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
