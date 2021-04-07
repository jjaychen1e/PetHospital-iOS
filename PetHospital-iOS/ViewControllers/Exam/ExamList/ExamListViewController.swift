//
//  DiseaseListViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/30.
//

import UIKit

class ExamListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var exams: [Exam] = []

    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Exam>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        configureCollectionView()
        configureDataSource()
        
        let parameters = ["usrId": GlobalCache.shared.loginResult?.user.id]
        
        NetworkManager.shared.fetch(endPoint: .allExams, method: .POST, parameters: parameters) { (result: ResultEntity<[Exam]>?) in
            if let result = result {
                if result.code == .success, let data = result.data {
                    self.exams = data
                    
                    let snapshot = self.initialSnapshot()
                    self.dataSource.apply(snapshot, to: .main, animatingDifferences: true)
                    
                    ToastHelper.show(emoji: "🎉", title: "获取考试数据成功", subtitle: "共获取到 \(self.exams.count) 场考试。")
                } else {
                    ToastHelper.show(emoji: "⚠️", title: "返回数据错误", subtitle: "错误代码: \(result.code)")
                }
            }
        }
    }
}

extension ExamListViewController {
    private func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.backgroundColor = .clear
        listConfiguration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
        self.collectionView = collectionView
    }
    
    private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<Exam> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Exam>()

        snapshot.append(exams)
        return snapshot
    }
    
    private func configureDataSource() {

        let examCellRegistration = UICollectionView.CellRegistration<ExamCardListCell, Exam> { (cell, indexPath, exam) in
            // For custom cell, we just need to assign the data item to the cell.
            // The custom cell's updateConfiguration(using:) method will assign the
            // content configuration to the cell
            cell.exam = exam
            cell.automaticallyUpdatesBackgroundConfiguration = false
            cell.tapAction = { [weak self] in
                if let self = self {
                    if exam.finished {
                        let alertController = UIAlertController(title: "您已参加过这场考试", message: "请勿重复参加考试。", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let examVC = ExamDetailViewController()
                        examVC.exam = exam
                        self.present(examVC, animated: true) {
                            
                        }
                    }
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Exam>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, exam: Exam) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: examCellRegistration, for: indexPath, item: exam)
        }

        // load our initial data
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
}

extension ExamListViewController: UICollectionViewDelegate {
    
}
