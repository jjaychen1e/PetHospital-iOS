//
//  TouringViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import UIKit
import SwiftUI
import Alamofire
import SnapKit

class DepartmentViewModel: ObservableObject {
    @Published var departments: [Department] = []
}

class TouringViewController: UIViewController {
    
    var searchController: UISearchController!
    var departmentViewModel = DepartmentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        
        var departments = Array<Department>()
        for i in 0..<100 {
            departments.append(.init(id: i, name: "科室\(i)", description: "科室\(i)的描述", picture: "https://cdn.jsdelivr.net/gh/JJAYCHENFIGURE/Image/img/A02/avatar_2020_03_19_16_43.png", roleName: "科室\(i)的负责人", position: [], equipments: []))
        }
        departmentViewModel.departments = departments
        
        let touringListViewController = UIHostingController(rootView: TouringListView(departmentViewModel:  departmentViewModel))
        addChild(touringListViewController)
        self.view.addSubview(touringListViewController.view)
        touringListViewController.didMove(toParent: self)
        touringListViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
}

extension TouringViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var departments = Array<Department>()
        for i in 0..<100 {
            departments.append(.init(id: i, name: "科室\(i)", description: "科室\(i)的描述", picture: "https://cdn.jsdelivr.net/gh/JJAYCHENFIGURE/Image/img/A02/avatar_2020_03_19_16_43.png", roleName: "科室\(i)的负责人", position: [], equipments: []))
        }
        if let searchText = searchController.searchBar.text,
           searchText != "" {
            departmentViewModel.departments = departments.filter({ (department) -> Bool in
                department.name.localizedCaseInsensitiveContains(searchText)
            })
        } else {
            departmentViewModel.departments = departments
        }
    }
}
