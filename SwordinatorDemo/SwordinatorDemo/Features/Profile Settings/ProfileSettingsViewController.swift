//
//  ProfileSettingsViewController.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation
import UIKit
import Swordinator

class ProfileSettingsViewController: UIViewController, Coordinated {
    
    let viewModel: ProfileSettingsViewModel
    weak var coordinator: Coordinator?
    
    init(viewModel: ProfileSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    var sections: [TableSection] = [
        TableSection(name: nil, items: [
            .feedback,
            .version,
            .logout
        ])
    ]
    
    struct TableSection {
        let name: String?
        let items: [TableSectionRow]
    }
    
    enum TableSectionRow {
        case feedback
        case version
        case logout
        
        var iconName: String {
            switch self {
            case .feedback:
                return "person"
            case .version:
                return "info"
            case .logout:
                return "lock"
            }
        }
        
        var title: String {
            switch self {
            case .feedback:
                return "Feedback"
            case .version:
                return "Version"
            case .logout:
                return "Logout"
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ProfileSettingsListCell.self, forCellReuseIdentifier: ProfileSettingsListCell.identifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}

extension ProfileSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingsListCell.identifier, for: indexPath) as! ProfileSettingsListCell
        cell.setup(
            iconName: item.iconName,
            title: item.title,
            isDestructive: item == .logout,
            showDisclosureIndicator: item == .logout
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .logout:
            coordinator?.handle(step: AppStep.logout)
        default:
            ()
        }
    }
}
