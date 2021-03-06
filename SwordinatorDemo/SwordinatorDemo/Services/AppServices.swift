//
//  AppServices.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/11.
//

import Foundation

protocol Services: AnyObject {
    
    var isAuthenticated: Bool {get}
    func userDidLogin()
    func userDidLogout()
    
    var isSyncRequired: Bool {get}
    var tasks: [Task] {get set}
    func lazyTask(id: Int, completion: @escaping ((Task?) -> Void))
}

protocol HasServices: AnyObject {
    var services: Services {get}
}

class AppServices: Services {
    
    // Auth
    var isAuthenticated: Bool {
        return UserDefaults.standard.bool(forKey: "kSwordinatorLoggedIn")
    }
    
    func userDidLogin() {
        UserDefaults.standard.set(true, forKey: "kSwordinatorLoggedIn")
    }
    
    func userDidLogout() {
        UserDefaults.standard.set(false, forKey: "kSwordinatorLoggedIn")
    }
    
    // Sync
    var isSyncRequired: Bool {
        return true
    }
    
    // Data
    var tasks: [Task] = [
        Task(id: 0, name: "Buy Milk"),
        Task(id: 1, name: "Walk the dog"),
        Task(id: 2, name: "Code something nice")
    ]
    
    func lazyTask(id: Int, completion: @escaping ((Task?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion(self.tasks.filter({ $0.id == id }).first)
        }
    }
}
