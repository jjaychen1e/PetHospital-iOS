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
    
    enum Section {
        case main
    }
    
    var searchController: UISearchController!
    
    private var _departments: [Department] = []
    var departments: [Department] = []
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Department>!
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewHierachy()
        fetchDepartments()
        
        let barItem = UIBarButtonItem()
        barItem.title = "退出登录"
        navigationItem.rightBarButtonItem = barItem
        barItem.target = GlobalCache.shared
        barItem.action = #selector(GlobalCache.shared.clearLoginCache)
    }
    
    private func fetchDepartments() {
        NetworkManager.shared.fetch(endPoint: .allDepartments, method: .POST) { (result: ResultEntity<[Department]>?) in
            self.refreshControl.endRefreshing()
            
            if let result = result {
                if result.code == .success, let departments = result.data {
                    self.departments = departments
                    self._departments = departments
                    let snapshot = self.initSnapshot()
                    self.dataSource.apply(snapshot, to: .main, animatingDifferences: true)
                } else {
                    print(result)
                }
            }
        }
    }
    
    private func setViewHierachy() {
        setCollectionView()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.backgroundColor = .clear
        listConfiguration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.refreshControl = self.refreshControl
        self.refreshControl.addAction(UIAction(handler: { (action) in
            self.fetchDepartments()
        }), for: .valueChanged)
        
        setDataSource()
    }
    
    private func setDataSource() {
        let departmentCardCellRegistration = UICollectionView.CellRegistration<DepartmentCardCell, Department> { (cell, indexPath, department) in
            cell.department = department
            cell.automaticallyUpdatesBackgroundConfiguration = false
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Department>(collectionView: collectionView) { (collectionView, indexPath, department) in
            let cell = collectionView.dequeueConfiguredReusableCell(using: departmentCardCellRegistration, for: indexPath, item: department)
            cell.tapAction = { [weak self] in
                let viewModel = DepartmentCardViewModel()
                viewModel.department = department
                self?.present(UIHostingController(rootView: DepartmentDetail2D(viewModel: viewModel)), animated: true, completion: nil)
            }
            return cell
        }
        
        let snapshot = initSnapshot()
        dataSource.apply(snapshot, to: .main, animatingDifferences: true)
    }
    
    private func initSnapshot() -> NSDiffableDataSourceSectionSnapshot<Department> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Department>()
        
        snapshot.append(departments)
        return snapshot
    }
}

extension TouringViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText != "" {
            departments = _departments.filter({ (department) -> Bool in
                department.name.localizedCaseInsensitiveContains(searchText)
            })
        } else {
            departments = _departments
        }
        
        let snapshot = self.initSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: true)
    }
}
