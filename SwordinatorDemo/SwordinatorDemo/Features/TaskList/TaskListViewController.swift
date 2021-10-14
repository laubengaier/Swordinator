//
//  TaskListViewController.swift
//  CoordinatorPattern
//
//  Created by Laubengaier, Timotheus | MTSD on 2021/10/05.
//

import Foundation
import UIKit
import Swordinator

class TaskListViewController: UIViewController, Coordinated {
    
    weak var coordinator: Coordinator?
    let viewModel: TaskListViewModel
    
    var showAddTask: Bool = false
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: UI
    lazy var overlayView: UIButton = {
        let view = UIButton(type: .custom, primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.hideAddTaskView()
        }))
        view.backgroundColor = .black.withAlphaComponent(0.75)
        view.alpha = 0
        return view
    }()
    
    let overlayTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
    
    lazy var addTaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var addTaskTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Add task..."
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.font = .systemFont(ofSize: 14, weight: .medium)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.identifier)
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        return view
    }()
    
    lazy var newTaskButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let view = UIButton(configuration: config, primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.showAddTaskView()
        }))
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalTo(view)
        }
        
        view.addSubview(newTaskButton)
        newTaskButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.size.equalTo(50)
        }
        
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(addTaskView)
        addTaskView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(90)
            make.leading.trailing.equalTo(view).inset(0)
            make.height.equalTo(70)
        }
        
        addTaskTextField.delegate = self
        view.addSubview(addTaskTextField)
        addTaskTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(addTaskView)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        //overlayTapRecognizer.isEnabled = false
        //overlayView.addGestureRecognizer(overlayTapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc
    func tapped() {
        hideAddTaskView()
    }
    
    func showAddTaskView() {
        self.showAddTask = true
        self.overlayTapRecognizer.isEnabled = true
        self.addTaskTextField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = self.showAddTask ? 1 : 0
        } completion: { finished in
            // done
        }
    }
    
    func hideAddTaskView() {
        self.showAddTask = false
        self.addTaskTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = self.showAddTask ? 1 : 0
        } completion: { finished in
            // done
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }

        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut) {
            self.addTaskView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view).offset(-keyboardSize.height)
            }
            self.view.layoutIfNeeded()
        } completion: { finished in
            //
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut) {
            self.addTaskView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view).offset(90)
            }
            self.view.layoutIfNeeded()
        } completion: { finished in
            //
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = viewModel.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.identifier, for: indexPath) as! TaskListCell
        cell.setup(task: task)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        coordinator?.handle(step: AppStep.taskDetail(task: task, completion: { [weak self] in
            self?.tableView.reloadData()
        }))
    }
}

// MARK: - UITextFieldDelegate
extension TaskListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            viewModel.tasks.append(Task(id: viewModel.tasks.count, name: text))
            textField.text = nil
            tableView.reloadData()
        }
        return true
    }
}
