//
//  AppDeeplinkStep+Convert.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/19.
//

import Foundation

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
        
        if host == "newTask" {
            return .taskDetail(task: Task(id: 10, name: "Test1"))
        } else if host == "tasks", let path = Int(url.pathComponents[1]) {
            return .taskDetailLazy(id: path)
        } else if host == "tasks" {
            return .tasks
        } else if host == "profile" {
            return .profile
        } else if host == "logout" {
            return .logout
        } else if host == "settings" {
            return .profileSettings
        }
        return nil
    }
}
