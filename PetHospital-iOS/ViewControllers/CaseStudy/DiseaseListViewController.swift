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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Disease>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        
        NetworkManager.shared.fetch(endPoint: .allDiseases) { (result: ResultEntity<[Disease]>?) in
            if let result = result {
                if result.code == .success, let data = result.data {
                    self.diseases = data
                    
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
        self.collectionView = collectionView
        collectionView.delegate = self
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<Disease> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Disease>()

        func addItems(_ diseases: [Disease], to parent: Disease?) {
            snapshot.append(diseases, to: parent)
            for disease in diseases where !(disease.children?.isEmpty ?? true) {
                addItems(disease.children!, to: disease)
            }
        }
        
        addItems(diseases, to: nil)
        return snapshot
    }
    
    private func configureDataSource() {
        
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Disease> { (cell, indexPath, disease) in
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
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Disease> { cell, indexPath, disease in
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = disease.name
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Disease>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, disease: Disease) -> UICollectionViewCell? in
            // Return the cell.
            if disease.children?.isEmpty ?? true {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: disease)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: disease)
            }
        }

        // load our initial data
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
}

extension DiseaseListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
//
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        if let viewController = menuItem.outlineViewController {
//            navigationController?.pushViewController(viewController.init(), animated: true)
//        }
//
//    }
}
