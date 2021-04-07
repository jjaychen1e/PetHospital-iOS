//
//  ExamDetailViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/3.
//

import UIKit

class ExamDetailViewController: UIViewController {
    
    var exam: Exam!
    var examPaper: ExamPaper?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    var questionViewControllers: [ExamQuestionViewController] = []
    var pageVC: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = ["paperId": exam.paperID]
        
        self.view.backgroundColor = .secondarySystemBackground
        self.title = "123"
        self.navigationItem.largeTitleDisplayMode = .never
        
        NetworkManager.shared.fetch(endPoint: .examPaperContent, method: .POST, parameters: parameters) { (result: ResultEntity<ExamPaper>?) in
            if let result = result {
                guard result.code == .success else {
                    return
                }
                
                if let examPaper = result.data {
                    self.examPaper = examPaper
                    self.setViewHierachy()
                }
            }
        }
    }
    
    private func confirmAllAnswer() {
        
        for (index, questionViewConroller) in questionViewControllers.enumerated() {
            if questionViewConroller.examQuestion.selectedChoice == nil {
                let alertController = UIAlertController(title: "您有尚未完成的题目", message: "请完成第 \(index + 1) 题再提交。", preferredStyle: .alert)
                alertController.addAction(.init(title: "确定", style: .default, handler: { (action) in
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                    if let targetIndex = self.dataSource.itemIdentifier(for: indexPath),
                       let currentVC = self.pageVC.viewControllers?.first as? ExamQuestionViewController,
                       let currentIndex = self.questionViewControllers.firstIndex(of: currentVC) {
                        if targetIndex > currentIndex, targetIndex < self.questionViewControllers.count {
                            self.pageVC.setViewControllers([self.questionViewControllers[targetIndex]], direction: .forward, animated: true, completion: nil)
                        } else if targetIndex < currentIndex, targetIndex >= 0 {
                            self.pageVC.setViewControllers([self.questionViewControllers[targetIndex]], direction: .reverse, animated: true, completion: nil)
                        }
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        var score = 0
        
        questionViewControllers.forEach {
            if $0.examQuestion.selectedChoice! == $0.examQuestion.answer {
                score += $0.examQuestion.score
            }
        }
        
        let parameters = [
            "usrId": GlobalCache.shared.loginResult?.user.id,
            "examId": exam.examID,
            "score": score,
        ]
        
        NetworkManager.shared.fetch(endPoint: .saveExamResult, method: .POST, parameters: parameters) { (result: ResultEntity<Bool>?) in
            if let result = result {
                if result.code == .success {
                    let alertController = UIAlertController(title: "保存成功", message: "您的成绩为 \(score) 分", preferredStyle: .alert)
                    alertController.addAction(.init(title: "确定", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setViewHierachy() {
        if let examPaper = examPaper, !examPaper.questions.isEmpty {
            examPaper.questions.enumerated().forEach { (index, question) in
                let questionVC = ExamQuestionViewController()
                questionVC.examQuestion = question
                if index == examPaper.questions.count - 1 {
                    questionVC.showConfirmButton = true
                    questionVC.confirmAction = confirmAllAnswer
                }
                self.questionViewControllers.append(questionVC)
            }
            
            pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageVC.setViewControllers([self.questionViewControllers.first!], direction: .forward, animated: true) { (completed) in
                
            }
            self.view.addSubview(pageVC.view)
            self.addChild(pageVC)
            pageVC.didMove(toParent: self)
            pageVC.view.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
            }
            pageVC.dataSource = self
            pageVC.delegate = self
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
            collectionView.alwaysBounceVertical = false
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            view.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(pageVC.view.snp.top)
                make.height.equalTo(90)
            }
            
            self.configureDataSource()
            self.applyInitialSnapshots()
            
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 24)
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func configureDataSource() {
        // create registrations up front, then choose the appropriate one to use in the cell provider
        let gridCellRegistration = createGridCellRegistration()
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: indexPath.row)
        }
    }
    
    private func createGridCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        return UICollectionView.CellRegistration<UICollectionViewCell, Int> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.cell()
            content.text = "\(item + 1)"
            content.textProperties.font = .boldSystemFont(ofSize: 30)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
            cell.backgroundConfiguration = background
        }
    }
    
    private func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
        
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Int>()
        sectionSnapshot.append(Array(0..<questionViewControllers.count))
        dataSource.apply(sectionSnapshot, to: 0, animatingDifferences: false)
    }
}

extension ExamDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let first = self.questionViewControllers.firstIndex(of: viewController as! ExamQuestionViewController), first > 0 {
            return self.questionViewControllers[first - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let first = self.questionViewControllers.firstIndex(of: viewController as! ExamQuestionViewController), first < self.questionViewControllers.count - 1 {
            return self.questionViewControllers[first + 1]
        }
        return nil
    }
    
}

extension ExamDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        collectionView.selectItem(at: IndexPath(row: self.questionViewControllers.firstIndex(of: pageViewController.viewControllers!.first! as! ExamQuestionViewController)!, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension ExamDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let targetIndex = dataSource.itemIdentifier(for: indexPath),
           let currentVC = pageVC.viewControllers?.first as? ExamQuestionViewController,
           let currentIndex = questionViewControllers.firstIndex(of: currentVC) {
            if targetIndex > currentIndex, targetIndex < questionViewControllers.count {
                pageVC.setViewControllers([questionViewControllers[targetIndex]], direction: .forward, animated: true, completion: nil)
            } else if targetIndex < currentIndex, targetIndex >= 0 {
                pageVC.setViewControllers([questionViewControllers[targetIndex]], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
}
