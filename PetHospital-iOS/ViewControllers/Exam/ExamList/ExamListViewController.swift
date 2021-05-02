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
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        
        configureCollectionView()
        configureDataSource()
        
        fetchData()
    }
    
    func fetchData() {
        let parameters = ["usrId": GlobalCache.shared.loginResult?.user.id]
        
        NetworkManager.shared.fetch(endPoint: .allExams, method: .POST, parameters: parameters) { (result: Result<ResultEntity<[Exam]>, Error>) in
            self.refreshControl.endRefreshing()
            
            result.resolve { result in
                if result.code == .success, let data = result.data {
                    self.exams = data
                    
                    let snapshot = self.initialSnapshot()
                    self.dataSource.apply(snapshot, to: .main, animatingDifferences: true)
                } else {
                    print(result)
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
        
        collectionView.refreshControl = refreshControl
        refreshControl.addAction(UIAction(handler: { (action) in
            self.fetchData()
        }), for: .valueChanged)
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                    if let startDateTime = dateFormatter.date(from: exam.startDateTime),
                       let endDateTime = dateFormatter.date(from: exam.endDateTime) {
                        let currentDateTime = Date()
                        if currentDateTime.timeIntervalSince1970 >= startDateTime.timeIntervalSince1970,
                           currentDateTime.timeIntervalSince1970 < endDateTime.timeIntervalSince1970 {
                            if exam.finished {
                                let alertController = UIAlertController(title: "您已参加过这场考试", message: "请勿重复参加考试。", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                if exam.questionNumber == 0 {
                                    let alertController = UIAlertController(title: "该场考试尚未就绪", message: "该场考试暂无考试内容，请稍后再试。", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                    return
                                }
                                let examVC = ExamDetailViewController()
                                examVC.exam = exam
                                examVC.examListViewController = self
                                self.present(examVC, animated: true) {
                                    
                                }
                            }
                        } else {
                            let alertController = UIAlertController(title: "考试时间未到", message: "尚未到该场考试时间，请在考试时间范围内参加考试。", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
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
