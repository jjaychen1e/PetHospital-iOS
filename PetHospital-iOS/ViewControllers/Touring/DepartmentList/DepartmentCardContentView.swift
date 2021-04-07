//
//  DepartmentCardContentView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/5.
//

import UIKit
import SwiftUI

class DepartmentCardContentView: UIView, UIContentView {
    
    private var departmentCardViewModel = DepartmentCardViewModel()
    
    private var currentConfiguration: DepartmentCardConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? DepartmentCardConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: DepartmentCardConfiguration) {
        super.init(frame: .zero)
        setViewHierachy()
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewHierachy() {
        let view = UIHostingController(rootView: DepartmentCardView(viewModel: departmentCardViewModel)).view!
        view.backgroundColor = .clear
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func apply(configuration: DepartmentCardConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        if let department = configuration.department {
            departmentCardViewModel.department = department
            departmentCardViewModel.tapAction = configuration.tapAction
        }
    }
}
