//
//  TaskDetailCoordinator.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class TaskDetailCoordinator: NavigationControllerCoordinator, ParentCoordinated, Deeplinkable
{
    weak var rootCoordinator: (Coordinator & Deeplinkable)?
    var parent: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    let services: AppServices
    var task: Task
    var taskCompletion: (() -> Void)?
    
    enum Event {
        case close
    }
    
    init(navigationController: UINavigationController, services: AppServices, task: Task, taskCompletion: (() -> Void)? = nil) {
        self.navigationController = navigationController
        self.services = services
        self.task = task
        self.taskCompletion = taskCompletion
        start()
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func start() {
        print("➡️ navigated to \(String(describing: Self.self))")
        
        let vm = TaskDetailViewModel(task: task)
        let vc = TaskDetailViewController(viewModel: vm)
        vc.coordinator = self
        self.navigationController.setViewControllers([
            vc
        ], animated: false)
        //navigationController.pushViewController(vc, animated: true)
    }
    
    func handle(step: Step) {
        guard let step = step as? AppStep else { return }
        switch step {
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
    private func showReminder(task: Task) {
        let vc = TaskDetailReminderViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPriority(task: Task) {
        let vc = TaskDetailReminderViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func close() {
        taskCompletion?()
        parent?.handle(step: AppStep.taskDetailClose)
    }
    
    private func dismiss() {
        taskCompletion?()
        navigationController.dismiss(animated: true, completion: nil)
        parent?.handle(step: AppStep.taskDetailClose)
    }
}
