//
//  SyncViewController.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/13.
//

import Foundation
import UIKit
import Swordinator

class SyncViewController: UIViewController, Coordinated {
    
    weak var coordinator: Coordinator?
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .systemGray
        return view
    }()
    
    lazy var indicatorLabel: UILabel = {
        let view = UILabel()
        view.text = "Loading..."
        view.font = .systemFont(ofSize: 12, weight: .bold)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(50)
        }
        
        view.addSubview(indicatorLabel)
        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(5)
            make.centerX.equalTo(view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.indicatorLabel.text = "Fetching..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.indicatorLabel.text = "Chopping trees..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.indicatorLabel.text = "Wire cables..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.coordinator?.handle(step: AppStep.syncCompleted)
        }
    }
    
}
