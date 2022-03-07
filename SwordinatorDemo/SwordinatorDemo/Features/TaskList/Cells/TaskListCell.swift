//
//  TaskListCell.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/09.
//

import Foundation
import UIKit

class TaskListCell: UITableViewCell {
    
    static let identifier = "TaskListCell"
    
    var task: Task? {
        didSet {
            guard let task = task else { return }
            updateView(task: task)
        }
    }
    
    lazy var completedButton: UIButton = {
        let view: UIButton
        if #available(iOS 14.0, *) {
            view = UIButton(type: .custom, primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.toggleCompleted()
            }))
        } else {
            view = UIButton(type: .custom)
            view.addTarget(self, action: #selector(onCompletedPressed), for: .touchUpInside)
        }
        view.setImage(UIImage(systemName: "circle"), for: .normal)
        view.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        view.tintColor = .label
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .medium)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(completedButton)
        completedButton.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).inset(10)
            make.size.equalTo(30)
            make.bottom.equalTo(contentView).inset(10).priority(999)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(completedButton.snp.trailing).offset(5)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func setup(task: Task) {
        self.task = task
    }
    
    private func updateView(task: Task) {
        self.completedButton.isSelected = task.completed
        if task.completed {
            if #available(iOS 15, *) {
                self.titleLabel.attributedText = try? NSAttributedString(markdown: "~" + task.name + "~")
            } else {
                self.titleLabel.attributedText = NSAttributedString(string: task.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single])
            }
        } else {
            self.titleLabel.attributedText = NSAttributedString(string: task.name)
        }
    }
    
    private func toggleCompleted() {
        self.completedButton.isSelected = !self.completedButton.isSelected
        self.task?.completed = self.completedButton.isSelected
        guard let task = self.task else { return }
        self.updateView(task: task)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        completedButton.isSelected = false
        self.titleLabel.attributedText = NSAttributedString()
    }
    
    @objc
    private func onCompletedPressed() {
        self.toggleCompleted()
    }
}
