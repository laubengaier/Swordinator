//
//  AppStep.swift
//  SimpleCoordinatorDemo
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/08.
//

import Foundation
import Swordinator

enum AppStep: Step {
    
    // task
    case taskDetail(task: Task, completion: (() -> Void)?)
    case taskDetailReminder(task: Task)
    case taskDetailPriority(task: Task)
    case lazyTaskDetail(id: Int)
    
    // auth
    case authWithSIWA
    case authCompleted
    case logout
    
    // sync
    case sync
    case syncCompleted
    
    // navigation
    case close
    case dismiss
    case pop
}

enum AppDeeplinkStep: DeeplinkStep {
    case taskDetail(task: Task)
    case lazyTaskDetail(id: Int)
    case tasks
    case profile
    case logout
}

extension AppDeeplinkStep {
    static func convert(url: URL) -> AppDeeplinkStep? {
        guard
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        guard
            let host = components.host,
            let path = components.path
            //let params = components.queryItems
        else {
            return nil
        }
        print("host = \(host)")
        print("path = \(path)")
        
        if url.absoluteString.starts(with: "swordinator://newTask") {
            return .taskDetail(task: Task(id: 10, name: "Test1"))
        } else if host == "tasks", let path = Int(url.pathComponents[1]) {
            return .lazyTaskDetail(id: path)
        } else if host == "tasks" {
            return .tasks
        } else if host == "profile" {
            return .profile
        } else if host == "logout" {
            return .logout
        }
        return nil
    }
}
