//
//  DepartmentCardCell.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/5.
//

import UIKit

class DepartmentCardCell: UICollectionViewCell {
    var department: Department?
    var tapAction: () -> () = {}
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = DepartmentCardConfiguration().updated(for: state)

        newConfiguration.department = department
        newConfiguration.tapAction = tapAction
        
        contentConfiguration = newConfiguration
        
        backgroundConfiguration = .clear()
    }
}
