//
//  DiseaseListViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/30.
//

import UIKit

class DiseaseListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var diseases: [Disease] = []

    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        
        NetworkManager.shared.fetch(endPoint: .allDiseases) { (result: ResultEntity<[Disease]>?) in
            if let result = result {
                if result.code == .success, let data = result.data {
                    self.diseases = data
                    
                    self.fetchCases()
                    
                    // load our initial data
                    let snapshot = self.initialSnapshot()
                    self.dataSource.apply(snapshot, to: .main, animatingDifferences: true)
                    
                    ToastHelper.show(emoji: "🎉", title: "获取病种数据成功", subtitle: "共获取到 \(self.diseases.count) 个病种。")
                } else {
                    ToastHelper.show(emoji: "⚠️", title: "返回数据错误", subtitle: "错误代码: \(result.code)")
                }
            }
        }
    }
    
    private func fetchCases() {
        if !diseases.isEmpty {
            let originalDiseaseEnumerated = diseases.enumerated()
            var updatedDisease = diseases
            for (index, disease) in originalDiseaseEnumerated {
                for (index2, subDisease) in (disease.children ?? []).enumerated() {
                    NetworkManager.shared.fetch(endPoint: .findDiseaseCase, method: .GET, parameters: ["name" : subDisease.name]) { (result: ResultEntity<DiseaseCaseResult>?) in
                        if let result = result {
                            if result.code == .success, let cases = result.data {
                                updatedDisease[index].children![index2].cases = cases.content
                                self.diseases = updatedDisease
                                let snapshot = self.initialSnapshot()
                                self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
                            } else {
                                print(result)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension DiseaseListViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        self.collectionView = collectionView
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<AnyHashable> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()

        func addItems(_ diseases: [Disease], to parent: Disease?) {
            snapshot.append(diseases, to: parent)
            for disease in diseases where !(disease.children?.isEmpty ?? true) {
                addItems(disease.children!, to: disease)
            }
            
            for disease in diseases where !(disease.cases?.isEmpty ?? true) {
                addCases(disease.cases ?? [], to: disease)
            }
        }
        
        func addCases(_ cases: [DiseaseCase], to parent: Disease?) {
            snapshot.append(cases, to: parent)
        }
        
        addItems(diseases, to: nil)
        return snapshot
    }
    
    private func configureDataSource() {
        
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AnyHashable> { (cell, indexPath, disease) in
            guard let disease = disease as? Disease else {
                return
            }
            
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = disease.name
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let label = UILabel()
            label.text = "共 \(disease.children?.count ?? 0) 个子病种"
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = Asset.dynamicGray.color
            let labelAccessory = UICellAccessory.customView(configuration: .init(customView: label, placement: .trailing()))
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions), labelAccessory]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AnyHashable> { cell, indexPath, disease in
            guard let disease = disease as? Disease else {
                return
            }
            
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = disease.name
            cell.contentConfiguration = contentConfiguration
            
            let label = UILabel()
            label.text = "共 \(disease.cases?.count ?? 0) 个病例"
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = Asset.dynamicGray.color
            let labelAccessory = UICellAccessory.customView(configuration: .init(customView: label, placement: .trailing()))
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions), labelAccessory]
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let caseCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AnyHashable> { cell, indexPath, diseaseCase in
            guard let diseaseCase = diseaseCase as? DiseaseCase else {
                return
            }
            
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "病例 \(diseaseCase.caseID) - \(diseaseCase.name)"
            cell.contentConfiguration = contentConfiguration
            
            let label = UILabel()
            label.text = diseaseCase.createTime
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = Asset.dynamicGray.color
            let labelAccessory = UICellAccessory.customView(configuration: .init(customView: label, placement: .trailing()))
            cell.accessories = [labelAccessory]
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            if let disease = item as? Disease {
                // Return the cell.
                if disease.children?.isEmpty ?? true {
                    return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: disease)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: disease)
                }
            } else if let diseaseCase = item as? DiseaseCase {
                let cell = collectionView.dequeueConfiguredReusableCell(using: caseCellRegistration, for: indexPath, item: diseaseCase)
                cell.automaticallyUpdatesContentConfiguration = false
                return cell
            } else {
                fatalError("Unsupported Data Type.")
            }
        }

        // load our initial data
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
}

extension DiseaseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let diseaseCase = self.dataSource.itemIdentifier(for: indexPath) as? DiseaseCase {
            let diseaseCaseDetailVC = DiseaseCaseDetailViewController()
            diseaseCaseDetailVC.diseaseCase = diseaseCase
            self.present(diseaseCaseDetailVC, animated: true) {
                
            }
        }
    }
}
