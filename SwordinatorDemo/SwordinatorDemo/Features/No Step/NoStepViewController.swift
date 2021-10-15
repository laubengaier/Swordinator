//
//  NoStepViewController.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation
import UIKit
import Swordinator

protocol NoStepViewControllerHandling: AnyObject {
    func handle(event: NoStepViewController.Event)
}


class NoStepViewController: UIViewController, Coordinated {
    
    enum Event {
        case noStepExample1
        case noStepExample2
    }
    
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "No Step"
        view.backgroundColor = .systemBackground
    }
    
}
