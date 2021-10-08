//
//  Task.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation

class Task {
    var id: Int
    var name: String
    var completed: Bool
    
    init(id: Int, name: String, completed: Bool = false) {
        self.id = id
        self.name = name
        self.completed = completed
    }
}
