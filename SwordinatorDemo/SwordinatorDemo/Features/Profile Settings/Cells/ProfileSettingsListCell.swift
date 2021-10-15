//
//  ProfileSettingsListCell.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation
import UIKit

class ProfileSettingsListCell: UITableViewCell {
    
    static let identifier = "ProfileSettingsListCell"
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .label
        view.contentMode = .scaleAspectFit
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
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.top.equalTo(contentView).inset(15)
            make.bottom.equalTo(contentView).inset(15).priority(999)
            make.size.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.top.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = ""
    }
    
    func setup(iconName: String, title: String, isDestructive: Bool = false, showDisclosureIndicator: Bool = false) {
        iconView.image = UIImage(systemName: iconName)
        titleLabel.text = title
        iconView.tintColor = isDestructive ? .systemRed : .label
        titleLabel.textColor = isDestructive ? .systemRed : .label
        accessoryType = showDisclosureIndicator ? .none : .disclosureIndicator
    }
}
