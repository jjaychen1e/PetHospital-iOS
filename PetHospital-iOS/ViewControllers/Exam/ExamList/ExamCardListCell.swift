//
//  ExamCardListCell.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/31.
//

import UIKit

class ExamCardListCell: UICollectionViewListCell {
    var exam: Exam?
    var tapAction: () -> () = {}
    
    override func updateConfiguration(using state: UICellConfigurationState) {

        // Create new configuration object and update it base on state
        var newConfiguration = ExamContentConfiguration().updated(for: state)

        // Update any configuration parameters related to data item
        newConfiguration.exam = exam
        newConfiguration.tapAction = tapAction

        // Set content configuration in order to update custom content view
        contentConfiguration = newConfiguration
        
        backgroundConfiguration = .clear()
    }
}
