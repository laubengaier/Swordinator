//
//  TaskListViewModel.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/12.
//

import Foundation

class TaskListViewModel {
    
    let services: AppServices
    
    var tasks: [Task]
    
    init(services: AppServices) {
        self.services = services
        self.tasks = services.tasks
    }
}
