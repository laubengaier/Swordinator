//
//  LoginViewController.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import SnapKit
import MBProgressHUD
import Swordinator

class LoginViewController: UIViewController {
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("🗑 \(String(describing: Self.self))")
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: UI
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [siwaButton])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 10
        return view
    }()
    
    lazy var siwaButton: UIButton = {
        let view: UIButton
        if #available(iOS 14.0, *) {
            view = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] (_) in
                guard let self = self else { return }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel.loginWithSIWA()
            }))
        } else {
            view = UIButton(type: .system)
            view.addTarget(self, action: #selector(onSIWALoginPressed), for: .touchUpInside)
        }
        view.setTitle("Sign in with Apple", for: .normal)
        view.setTitleColor(.systemBackground, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        view.backgroundColor = .label
        view.layer.cornerRadius = 10
        
        view.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        
        view.addSubview(siwaButton)
        siwaButton.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        viewModel.onAuthCompleted = { [weak self] in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc
    private func onSIWALoginPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.loginWithSIWA()
    }

}
