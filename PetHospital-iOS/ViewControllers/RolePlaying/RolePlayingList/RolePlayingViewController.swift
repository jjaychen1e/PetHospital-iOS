//
//  RolePlayingViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import UIKit
import SwiftUI
import SnapKit

class RolePlayingViewController: UIViewController {
    
    var roles: [Role] = []
    var roleStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        setViewHierachy()
        
        NetworkManager.shared.fetch(endPoint: .allRoles, method: .POST) { (result: ResultEntity<[Role]>?) in
            if let result = result {
                if result.code == .success, let roles = result.data {
                    self.roles = roles
                    roles.forEach { (role) in
                        let cardView = UIHostingController(rootView: RoleCardView(role: role, action: {
                            self.present(UIHostingController(rootView: WorkflowListView(role: role)), animated: true, completion: nil)
                        })).view!
                        cardView.backgroundColor = .clear
                        self.roleStackView.addArrangedSubview(cardView)
                    }
                } else {
                    print(result)
                }
            }
        }
    }
    
    private func setViewHierachy() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        roleStackView = UIStackView()
        roleStackView.axis = .vertical
        roleStackView.alignment = .fill
        roleStackView.distribution = .fill
        scrollView.addSubview(roleStackView)
        roleStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
