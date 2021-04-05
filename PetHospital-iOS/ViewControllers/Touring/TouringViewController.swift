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

class TouringViewController: UIViewController {
    
    var searchController: UISearchController!
    var departments: [Department] = []
    
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewHierachy()
        
        NetworkManager.shared.fetch(endPoint: .allDepartments, method: .POST) { (result: ResultEntity<[Department]>?) in
            if let result = result {
                if result.code == .success, let departments = result.data {
                    self.departments = departments
                    departments.forEach { department in
                        self.stackView.addArrangedSubview({
                            let view = UIHostingController(rootView: DepartmentCardView(name: department.name, description: department.description)).view!
                            view.backgroundColor = .clear
                            return view
                        }())
                    }
                } else {
                    print(result)
                }
            }
        }
    }
    
    private func setViewHierachy() {
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
 
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

extension TouringViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        var departments = Array<Department>()
//        for i in 0..<100 {
//            departments.append(.init(id: i, name: "科室\(i)", description: "科室\(i)的描述", picture: "https://cdn.jsdelivr.net/gh/JJAYCHENFIGURE/Image/img/A02/avatar_2020_03_19_16_43.png", roleName: "科室\(i)的负责人", position: [], equipments: []))
//        }
//        if let searchText = searchController.searchBar.text,
//           searchText != "" {
//            departmentViewModel.departments = departments.filter({ (department) -> Bool in
//                department.name.localizedCaseInsensitiveContains(searchText)
//            })
//        } else {
//            departmentViewModel.departments = departments
//        }
    }
}
