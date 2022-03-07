//
//  LoginViewModel.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/11.
//

import Foundation
import Swordinator

class LoginViewModel: Coordinated {
    
    let services: AppServices
    weak var coordinator: Coordinator?
    
    var onAuthCompleted: (() -> Void)?
    
    init(services: AppServices, coordinator: LoginCoordinator) {
        self.services = services
        self.coordinator = coordinator
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    func loginWithSIWA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.services.userDidLogin()
            self.onAuthCompleted?()
            self.coordinator?.handle(step: AppStep.authWithSIWA)
        }
    }
}
