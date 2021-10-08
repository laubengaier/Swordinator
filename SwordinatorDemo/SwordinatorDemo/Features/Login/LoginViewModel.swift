//
//  LoginViewModel.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/11.
//

import Foundation

class LoginViewModel {
    
    let services: AppServices
    
    var onAuthCompleted: (() -> Void)?
    
    init(services: AppServices) {
        self.services = services
    }
    
    func loginWithSIWA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.services.userDidLogin()
            self.onAuthCompleted?()
        }
    }
}
