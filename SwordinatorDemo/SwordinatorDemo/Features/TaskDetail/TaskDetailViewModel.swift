//
//  TaskDetailViewModel.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation

class TaskDetailViewModel {
    
    var task: Task
    var onTaskCompletion: (() -> Void)?
    init(task: Task, onTaskCompletion: (() -> Void)?) {
        self.task = task
        self.onTaskCompletion = onTaskCompletion
    }
}
