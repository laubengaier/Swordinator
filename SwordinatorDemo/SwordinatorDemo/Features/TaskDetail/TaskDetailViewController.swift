//
//  TaskDetailViewController.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class TaskDetailViewController: UIViewController, Coordinated {
    
    let viewModel: TaskDetailViewModel
    weak var coordinator: Coordinator?
    var sections: [TableSection] = [
        TableSection(name: nil, items: [.title, .reminder, .priority])
    ]
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TaskDetailNameCell.self, forCellReuseIdentifier: TaskDetailNameCell.identifier)
        view.register(TaskDetailSelectableCell.self, forCellReuseIdentifier: TaskDetailSelectableCell.identifier)
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        return view
    }()
    
    struct TableSection {
        let name: String?
        let items: [TableSectionRow]
    }
    
    enum TableSectionRow {
        case title
        case reminder
        case priority
    }
    
    lazy var closeBarButton: UIBarButtonItem = {
        if #available(iOS 14.0, *) {
            let view = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.handle(step: AppStep.dismiss)
            }), menu: nil)
            return view
        } else {
            let view = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onDismissPressed))
            return view
        }
    }()
    
    init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        view.backgroundColor = .systemBackground
        
        navigationItem.setLeftBarButton(closeBarButton, animated: true)
        navigationController?.presentationController?.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //coordinator?.handle(event: .pop)
    }
    
    @objc
    func onDismissPressed() {
        viewModel.onTaskCompletion?()
        self.coordinator?.handle(step: AppStep.dismiss)
    }
}

extension TaskDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.onTaskCompletion?()
        coordinator?.handle(step: AppStep.close)
    }
}

extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailNameCell.identifier, for: indexPath) as! TaskDetailNameCell
            cell.setup(task: viewModel.task)
            cell.onChangeCompleted = { [weak self] completed in
                guard let self = self else { return }
                self.viewModel.task.completed = completed
            }
            cell.onChangeName = { [weak self] text in
                guard let self = self else { return }
                self.viewModel.task.name = text ?? ""
            }
            return cell
        case .reminder:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailSelectableCell.identifier, for: indexPath) as! TaskDetailSelectableCell
            cell.iconView.image = UIImage(systemName: "clock")
            cell.titleLabel.text = "Reminder"
            return cell
        case .priority:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailSelectableCell.identifier, for: indexPath) as! TaskDetailSelectableCell
            cell.iconView.image = UIImage(systemName: "flag")
            cell.titleLabel.text = "Priority"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .title:
            ()
        case .reminder:
            self.coordinator?.handle(step: AppStep.taskDetailReminder(task: viewModel.task))
        case .priority:
            self.coordinator?.handle(step: AppStep.taskDetailPriority(task: viewModel.task))
        }
    }
}
