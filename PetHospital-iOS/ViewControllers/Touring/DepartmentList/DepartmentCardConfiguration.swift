//
//  DepartmentCardConfiguration.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/5.
//

import UIKit

struct DepartmentCardConfiguration: UIContentConfiguration, Equatable {
    static func == (lhs: DepartmentCardConfiguration, rhs: DepartmentCardConfiguration) -> Bool {
        lhs.department == rhs.department
    }
    
    var department: Department?
    var tapAction: () -> () = {}
    
    func makeContentView() -> UIView & UIContentView {
        DepartmentCardContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> DepartmentCardConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        
        var updatedConfiguration = self
        
        return updatedConfiguration
    }
}
