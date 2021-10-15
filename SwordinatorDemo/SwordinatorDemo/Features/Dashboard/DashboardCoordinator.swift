//
//  DashboardCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class DashboardCoordinator: NSObject, TabBarControllerCoordinator, ParentCoordinated, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices

    init(tabBarController: UITabBarController, services: AppServices) {
        self.tabBarController = tabBarController
        self.services = services
        super.init()
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        print("➡️ navigated to \(String(describing: Self.self))")
        
        tabBarController.delegate = self
        
        let nvc1 = UINavigationController()
        nvc1.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: "app"), tag: 0)
        let taskListCoordinator = TaskListCoordinator(navigationController: nvc1, services: services)
        taskListCoordinator.parent = self
        childCoordinators.append(taskListCoordinator)
        
        let nvc2 = UINavigationController()
        nvc2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        let profileCoordinator = ProfileCoordinator(navigationController: nvc2, services: services)
        profileCoordinator.parent = self
        childCoordinators.append(profileCoordinator)


        tabBarController.setViewControllers([
            nvc1,
            nvc2
        ], animated: false)

        // assign the selected root & update via tabbar delegate
        rootCoordinator = taskListCoordinator
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .profileSettings:
            self.showProfile(shouldSelect: true)
        case .logout:
            self.logout()
        default:
            ()
        }
    }
    
    func handle(deepLink: DeeplinkStep) {
        if let deepLink = deepLink as? AppDeeplinkStep {
            switch deepLink {
            case .tasks:
                self.showTasks(shouldSelect: true)
                return
            case .profile:
                self.showProfile(shouldSelect: true)
                return
            case .profileSettings:
                self.showProfileSettings()
                return
            default:
                ()
            }
        }
        if let root = rootCoordinator {
            root.handle(deepLink: deepLink)
        } else {
            // handle here
        }
    }
}

// MARK: - Actions
extension DashboardCoordinator {
    private func showTasks(shouldSelect: Bool = false) {
        guard
            let taskListCoordinator = childCoordinators.filter({ $0 is TaskListCoordinator }).first as? TaskListCoordinator
        else { return }
        if shouldSelect {
            tabBarController.selectedIndex = 0
        }
        rootCoordinator = taskListCoordinator
        print("🔄 changed rootCoordinator to taskList")
    }
    
    private func showProfile(shouldSelect: Bool = false, forwardStep: DeeplinkStep? = nil) {
        guard
            let profileCoordinator = childCoordinators.filter({ $0 is ProfileCoordinator }).first as? ProfileCoordinator
        else { return }
        if shouldSelect {
            tabBarController.selectedIndex = 1
        }
        rootCoordinator = profileCoordinator
        if let forwardStep = forwardStep {
            profileCoordinator.handle(deepLink: forwardStep)
        }
        print("🔄 changed rootCoordinator to profile")
    }
    
    private func showProfileSettings() {
        if let taskListCoordinator = childCoordinators.filter({ $0 is TaskListCoordinator }).first {
            taskListCoordinator.handle(step: AppStep.closeChildren)
        }
        self.showProfile(shouldSelect: true, forwardStep: AppDeeplinkStep.profileSettings)
    }
    
    private func logout() {
        childCoordinators.removeAll { $0 is TaskListCoordinator }
        childCoordinators.removeAll { $0 is ProfileCoordinator }
        parent?.handle(step: AppStep.logout)
    }
}

// MARK: - UITabBarControllerDelegate
extension DashboardCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            self.showTasks()
            ()
        case 1:
            self.showProfile()
        default:
            ()
        }
    }
}
