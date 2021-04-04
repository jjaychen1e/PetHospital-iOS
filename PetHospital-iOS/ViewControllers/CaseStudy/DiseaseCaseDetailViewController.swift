//
//  DiseaseCaseDetailViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/4.
//

import UIKit
import SwiftUI

class DiseaseCaseDetailViewController: UIViewController {
    
    var diseaseCase: DiseaseCase!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondarySystemBackground
        
        setViewHierachy()
    }

    private func setViewHierachy() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "病例 \(diseaseCase.caseID) - \(diseaseCase.name)"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        let timeLabel = UILabel()
        timeLabel.text = "创建时间: \(diseaseCase.createTime)"
        timeLabel.font = .preferredFont(forTextStyle: .headline)
        
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.alignment = .leading
        headerStackView.distribution = .fill
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(timeLabel)
        
        scrollView.addSubview(headerStackView)
        headerStackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        let stepLabel = UILabel()
        stepLabel.text = "3个就诊步骤"
        stepLabel.font = .preferredFont(forTextStyle: .headline)
        scrollView.addSubview(stepLabel)
        stepLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(headerStackView.snp.bottom).offset(24)
        }
        
        let stepStackView = UIStackView()
        stepStackView.axis = .vertical
        stepStackView.alignment = .fill
        stepStackView.distribution = .fill
        let inspectionView = UIHostingController(rootView: CaseModuleCard(title: "病例检查", description: diseaseCase.inspection, index: 1)).view!
        inspectionView.backgroundColor = .clear
        let diagnosisView = UIHostingController(rootView: CaseModuleCard(title: "病例诊断", description: diseaseCase.diagnosis, index: 2)).view!
        diagnosisView.backgroundColor = .clear
        let treatmentView = UIHostingController(rootView: CaseModuleCard(title: "治疗方案", description: diseaseCase.treatment, index: 3)).view!
        treatmentView.backgroundColor = .clear
        stepStackView.addArrangedSubview(inspectionView)
        stepStackView.addArrangedSubview(diagnosisView)
        stepStackView.addArrangedSubview(treatmentView)
        scrollView.addSubview(stepStackView)
        stepStackView.snp.makeConstraints { (make) in
            make.top.equalTo(stepLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
