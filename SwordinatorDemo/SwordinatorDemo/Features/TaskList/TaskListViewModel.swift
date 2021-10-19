//
//  TaskListViewModel.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/12.
//

import Foundation

class TaskListViewModel {
    
    let services: Services
    
    var tasks: [Task]
    
    init(services: Services) {
        self.services = services
        self.tasks = services.tasks
    }
}
