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
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        
        var roles = Array<Role>()
        roles.append(Role(name: "医生", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "医助", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        let rolePlayingUIHostingViewController = UIHostingController(rootView: RolePlayingView(roles: roles))
        addChild(rolePlayingUIHostingViewController)
        self.view.addSubview(rolePlayingUIHostingViewController.view)
        rolePlayingUIHostingViewController.didMove(toParent: self)
        rolePlayingUIHostingViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
