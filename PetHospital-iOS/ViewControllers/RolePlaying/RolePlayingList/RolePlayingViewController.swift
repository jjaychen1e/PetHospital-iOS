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
    
    private var roles: [Role] = []
    private var roleStackView: UIStackView!
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        setViewHierachy()
        fetchRoles()
    }
    
    private func fetchRoles() {
        NetworkManager.shared.fetch(endPoint: .allRoles, method: .POST) { (result: Result<ResultEntity<[Role]>, Error>) in
            self.refreshControl.endRefreshing()
            
            result.resolve { result in
                if result.code == .success, let roles = result.data {
                    self.roles = roles
                    
                    for view in self.roleStackView.arrangedSubviews {
                        self.roleStackView.removeArrangedSubview(view)
                        view.removeFromSuperview()
                    }
                    
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
        
        scrollView.refreshControl = refreshControl
        refreshControl.addAction(UIAction(handler: { (actoin) in
            self.fetchRoles()
        }), for: .valueChanged)
        
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
