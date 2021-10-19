//
//  AppStep.swift
//  SimpleCoordinatorDemo
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/08.
//

import Foundation
import Swordinator
import UIKit
import MBProgressHUD

enum AppStep: Step {
    
    // task
    case taskDetail(task: Task, completion: (() -> Void)?)
    case taskDetailLazy(id: Int)
    case taskDetailReminder(task: Task)
    case taskDetailPriority(task: Task)
    case taskDetailCompleted
    
    // auth
    case authWithSIWA
    case authCompleted
    case logout
    
    // sync
    case sync
    case syncCompleted
    
    // profile
    case profile
    case profileSettings
    case profileSettingsCompleted
    
    // navigation
    case close
    case closeChildren
    case dismiss
    case pop
}

enum AppDeeplinkStep: DeeplinkStep {
    
    // task
    case taskDetail(task: Task)
    case taskDetailLazy(id: Int)
    
    // tabbar
    case tasks
    case profile
    
    // profile
    case profileSettings
    case logout
    
}
