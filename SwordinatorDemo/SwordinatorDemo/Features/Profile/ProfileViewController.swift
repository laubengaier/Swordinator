//
//  ProfileViewController.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class ProfileViewController: UIViewController, Coordinated {
    
    let viewModel: ProfileViewModel
    weak var coordinator: Coordinator?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - UI
    // MARK: Menu
    var settingItems: [UIAction] {
        return [
            UIAction(
                title: "Logout", attributes: .destructive, handler: { [weak self] (_) in
                self?.coordinator?.handle(step: AppStep.logout)
            }),
        ]
    }
    
    var settingsMenu: UIMenu {
        return UIMenu(title: "Settings", image: nil, identifier: nil, options: [], children: settingItems)
    }
    
    lazy var settingsBarButton: UIBarButtonItem = {
        let view: UIBarButtonItem
        if #available(iOS 14.0, *) {
            view = UIBarButtonItem(title: nil, image: UIImage(systemName: "gearshape"), primaryAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.handle(step: AppStep.profileSettings)
            }), menu: nil)
        } else {
            view = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(onSettingsPressed))
        }
        return view
    }()
    
    lazy var profilePictureButton: UIButton = {
        if #available(iOS 15.0, *) {
            let config = UIButton.Configuration.plain()
            let view = UIButton(configuration: config, primaryAction: nil)
            view.isUserInteractionEnabled = false
            view.backgroundColor = .systemGray3
            view.layer.cornerRadius = 40
            return view
        } else {
            let view: UIButton
            if #available(iOS 14.0, *) {
                view = UIButton(type: .custom, primaryAction: nil)
            } else {
                view = UIButton(type: .custom)
            }
            view.isUserInteractionEnabled = false
            view.backgroundColor = .systemGray3
            view.layer.cornerRadius = 40
            return view
        }
    }()
    
    lazy var userNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.text = "SwordUser#1337"
        view.textAlignment = .center
        view.textColor = .systemGray
        return view
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        navigationItem.setRightBarButton(settingsBarButton, animated: true)
        
        view.addSubview(profilePictureButton)
        profilePictureButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view)
            make.size.equalTo(80)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profilePictureButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(40)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc
    private func onSettingsPressed() {
        coordinator?.handle(step: AppStep.profileSettings)
    }
}
