//
//  ProfileSettingsViewModel.swift
//  SwordinatorDemo
//
//  Created by Timotheus Laubengaier on 2021/10/15.
//

import Foundation

class ProfileSettingsViewModel {
    
    let services: Services
    
    var sections: [TableSection] = [
        TableSection(name: nil, items: [
            .feedback,
            .version,
            .logout
        ])
    ]
    
    init(services: Services) {
        self.services = services
    }
}

// MARK: - Sections
extension ProfileSettingsViewModel {
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
}
