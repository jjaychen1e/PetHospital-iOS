//
//  ExamCardContentView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/31.
//

import UIKit
import SwiftUI

class ExamCardContentView: UIView, UIContentView {
    private var cardViewModel = ExamListCardViewModel()
    private var cardView: UIView!
    
    private var currentConfiguration: ExamContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ExamContentConfiguration else {
                return
            }
            
            // Apply the new configuration to ExamCardContentView
            // also update currentConfiguration to newConfiguration
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: ExamContentConfiguration) {
        super.init(frame: .zero)
        setupAllViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAllViews() {
        cardView = UIHostingController(rootView: ExamListCard(viewModel: cardViewModel)).view!
        cardView.backgroundColor = .clear
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func apply(configuration: ExamContentConfiguration) {
        
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }

        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        if let exam = configuration.exam {
            self.cardViewModel.title = exam.examName
            self.cardViewModel.totalQuestionScore = exam.totalScore
            self.cardViewModel.totalQuestionNumber = exam.questionNumber
            self.cardViewModel.startDateTime = exam.startDateTime
            self.cardViewModel.endDateTime = exam.endDateTime
            self.cardViewModel.action = configuration.tapAction
        }
    }
}
