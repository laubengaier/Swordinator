//
//  TaskDetailNameCell.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/11.
//

import Foundation
import UIKit

class TaskDetailNameCell: UITableViewCell {
    
    static let identifier = "TaskDetailNameCell"
    
    var onChangeCompleted: ((Bool) -> Void)?
    var onChangeName: ((String?) -> Void)?
    
    lazy var completedButton: UIButton = {
        let view: UIButton
        if #available(iOS 14.0, *) {
            view = UIButton(type: .custom, primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.completedButton.isSelected = !self.completedButton.isSelected
                self.onChangeCompleted?(self.completedButton.isSelected)
            }))
        } else {
            view = UIButton(type: .system)
            view.addTarget(self, action: #selector(onCompletedPressed), for: .touchUpInside)
        }
        view.setImage(UIImage(systemName: "circle"), for: .normal)
        view.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        view.tintColor = .label
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Enter name..."
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.delegate = self
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(completedButton)
        completedButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.top.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).inset(20).priority(999)
            make.width.equalTo(20)
            make.height.equalTo(40)
        }
        
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.leading.equalTo(completedButton.snp.trailing).offset(10)
            make.top.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextField.text = ""
    }
    
    func setup(task: Task) {
        self.nameTextField.text = task.name
        self.completedButton.isSelected = task.completed
    }
    
    @objc
    private func onCompletedPressed() {
        completedButton.isSelected = !completedButton.isSelected
        onChangeCompleted?(completedButton.isSelected)
    }
}

extension TaskDetailNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onChangeName?(textField.text)
        nameTextField.resignFirstResponder()
        return true
    }
}
