//
//  ExamContentConfiguration.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/31.
//

import Foundation
import UIKit

struct ExamContentConfiguration: UIContentConfiguration, Equatable {
    static func == (lhs: ExamContentConfiguration, rhs: ExamContentConfiguration) -> Bool {
        lhs.exam == rhs.exam
    }
    
    var exam: Exam?
    var tapAction: () -> () = {}
    
    func makeContentView() -> UIView & UIContentView {
        ExamCardContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ExamContentConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        
        var updatedConfiguration = self
        
        return updatedConfiguration
    }
    
}
