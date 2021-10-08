//
//  AppServices.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/11.
//

import Foundation

class AppServices {
    
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
    
    // Data
    var tasks: [Task] = [
        Task(id: 0, name: "Buy Milk"),
        Task(id: 1, name: "Walk the dog"),
        Task(id: 2, name: "Code something nice")
    ]
}
