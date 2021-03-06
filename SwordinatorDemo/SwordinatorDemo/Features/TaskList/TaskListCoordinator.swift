//
//  TaskListCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator
import MBProgressHUD

class TaskListCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable, HasServices
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
        case .taskList:
            navigateToTaskList()
        case .taskDetail(let task, let completion):
            showTaskDetail(task: task, completion: completion)
        case .taskDetailCompleted:
            closeTaskDetail()
        
        case .logout:
            logout()
        case .closeChildren:
            closeChildren()
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
                self.showTaskDetail(task: task, completion: nil)
            case .taskDetailLazy(let id):
                showTaskDetailLazy(id: id)
            default:
                ()
            }
        }
    }
}

// MARK: - Actions
extension TaskListCoordinator
{
    private func navigateToTaskList() {
        let vm = TaskListViewModel(services: services)
        let vc = TaskListViewController(viewModel: vm)
        vc.coordinator = self
        self.navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    private func showTaskDetail(task: Task, completion: (() -> Void)?) {
        let nvc = UINavigationController()
        let coordinator = TaskDetailCoordinator(navigationController: nvc, services: services, step: .taskDetail(task: task, completion: completion))
        coordinator.parent = self
        navigationController.present(nvc, animated: true, completion: nil)
        childCoordinators.append(coordinator)
    }
    
    private func showTaskDetailLazy(id: Int) {
        MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        services.lazyTask(id: id) { task in
            MBProgressHUD.hide(for: self.navigationController.view, animated: true)
            guard let task = task else { return }
            self.showTaskDetail(task: task, completion: nil)
        }
    }
    
    private func closeTaskDetail() {
        childCoordinators.removeAll { $0 is TaskDetailCoordinator }
    }
    
    private func navigateToProfileSettings() {
        childCoordinators.removeAll { $0 is TaskDetailCoordinator }
        parent?.handle(step: AppStep.profileSettings)
    }
    
    private func closeChildren() {
        if let taskDetailCoordinator = childCoordinators.filter({ $0 is TaskDetailCoordinator }).first {
            taskDetailCoordinator.handle(step: AppStep.dismiss)
        }
    }
    
    private func logout() {
        parent?.handle(step: AppStep.logout)
    }
}
