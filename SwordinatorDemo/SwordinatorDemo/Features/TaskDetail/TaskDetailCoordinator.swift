//
//  TaskDetailCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class TaskDetailCoordinator: NavCoordinator, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: Services
    
    enum Event {
        case close
    }
    
    init(navigationController: UINavigationController, services: Services, step: AppStep) {
        self.navigationController = navigationController
        self.services = services
        //self.taskCompletion = taskCompletion
        start(step: step)
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start(step: Step) {
        print("⬇️ Navigated to \(String(describing: Self.self))")
        handle(step: step)
        
        //navigationController.pushViewController(vc, animated: true)
    }
    
    func handle(step: Step) {
        print("  ➡️ \(String(describing: Self.self)) -> \(step)")
        guard let step = step as? AppStep else { return }
        switch step {
        case .taskDetail(let task, let completion):
            navigateToTaskDetail(task: task, completion: completion)
        case .taskDetailReminder(let task):
            showReminder(task: task)
        case .taskDetailPriority(let task):
            showPriority(task: task)
        case .close:
            close()
        case .dismiss:
            dismiss()
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
extension TaskDetailCoordinator {
    private func navigateToTaskDetail(task: Task, completion: (() -> Void)?) {
        let vm = TaskDetailViewModel(task: task, onTaskCompletion: completion)
        let vc = TaskDetailViewController(viewModel: vm)
        vc.coordinator = self
        self.navigationController.setViewControllers([
            vc
        ], animated: false)
    }
    
    private func showReminder(task: Task) {
        let vc = TaskDetailReminderViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPriority(task: Task) {
        let vc = TaskDetailReminderViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func close() {
        endNavigateToTask(animated: false, shouldDismiss: false, completion: nil)
    }
    
    private func dismiss() {
        endNavigateToTask(animated: true, shouldDismiss: true, completion: nil)
    }
}
