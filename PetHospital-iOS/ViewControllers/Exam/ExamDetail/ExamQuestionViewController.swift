//
//  ExamQuestionViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/3.
//

import UIKit
import SwiftUI

class ExamQuestionViewController: UIViewController {
    
    var examQuestion: ExamQuestion!
    fileprivate var choiceButtons: [ChoiceButton] = []
    var showConfirmButton = false
    var confirmAction: () -> () = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewHierachy()
    }
    
    private func setViewHierachy() {
        self.view.backgroundColor = .clear
        
        // Outer scroll view
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // set stem label container view
        let stemLabelContainerView = UIView()
        scrollView.addSubview(stemLabelContainerView)
        stemLabelContainerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }

        // set stem label
        let stemLabel = UILabel()
        stemLabel.numberOfLines = 0
        stemLabel.textAlignment = .left
        stemLabel.text = examQuestion.stem
        stemLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        stemLabelContainerView.addSubview(stemLabel)
        stemLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }
        
        // set choices stack view
        let choicesStackView = UIStackView()
        choicesStackView.axis = .vertical
        choicesStackView.alignment = .fill
        choicesStackView.distribution = .fill
        choicesStackView.spacing = 24
        scrollView.addSubview(choicesStackView)
        choicesStackView.snp.makeConstraints { (make) in
            make.top.equalTo(stemLabel.snp.bottom).offset(46)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        examQuestion.choices.enumerated().forEach { (index, description) in
            let choiceButton = ChoiceButton(index: index, title: description)
            choiceButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choiceButtonTapped)))
            choicesStackView.addArrangedSubview(choiceButton)
            choiceButtons.append(choiceButton)
        }
        
        // set fianl confirm button(only the last question has this button)
        
        if showConfirmButton {
            let confirmButton = ConfirmButton(frame: .zero)
            scrollView.addSubview(confirmButton)
            confirmButton.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(choicesStackView.snp.bottom).offset(44)
                make.bottom.equalTo(scrollView).offset(24)
                make.height.equalTo(50)
            }
            
            confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped)))
            
        } else {
            scrollView.snp.makeConstraints { (make) in
                make.bottom.equalTo(choicesStackView).offset(16)
            }
        }
    }
    
    @objc
    private func choiceButtonTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let choiceButton = sender?.view as? ChoiceButton else {
            return
        }
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        self.examQuestion.selectedChoice = ExamQuestionChoice.convert(choiceIndex: choiceButton.index)
        
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            choiceButton.transform = .init(scaleX: 0.98, y: 0.98)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            choiceButton.transform = .init(scaleX: 1, y: 1)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.choiceButtons.enumerated().forEach { (index, button) in
                if self.examQuestion.selectedChoice == ExamQuestionChoice.convert(choiceIndex: index) {
                    let animation = CABasicAnimation(keyPath: "borderColor")
                    animation.fromValue = button.backgroundView.layer.borderColor
                    animation.toValue = UIColor.systemBlue.withAlphaComponent(1.0).cgColor
                    animation.duration = 0.3
                    button.backgroundView.layer.add(animation, forKey: "Color")
                    button.backgroundView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(1.0).cgColor
                    
                    button.selectedImage.alpha = 1
                } else {
                    let animation = CABasicAnimation(keyPath: "borderColor")
                    animation.fromValue = button.backgroundView.layer.borderColor
                    animation.toValue = UIColor.systemBlue.withAlphaComponent(0.0).cgColor
                    animation.duration = 0.3
                    button.backgroundView.layer.add(animation, forKey: "Color")
                    button.backgroundView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.0).cgColor
                    
                    button.selectedImage.alpha = 0
                }
            }
        }
    }
    
    @objc
    private func confirmButtonTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let confirmButton = sender?.view as? ConfirmButton else {
            return
        }
        
        confirmAction()
        
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            confirmButton.alpha = 0.3
            confirmButton.transform = CGAffineTransform.init(scaleX: 0.98, y: 0.98)
        } completion: { (completed) in
            if completed {
                UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                    confirmButton.alpha = 1.0
                    confirmButton.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }
}


fileprivate class ChoiceButton: UIView {
    var titleLabel: UILabel!
    var selectedImage: UIImageView!
    var backgroundView: UIView!
    var index: Int
    var title: String
    
    init(index: Int, title: String) {
        self.index = index
        self.title = title
        
        super.init(frame: .zero)
        
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = .init(width: 0, height: 1)
        self.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundView = UIView()
        backgroundView.layer.cornerRadius = 18
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.0).cgColor
        backgroundView.clipsToBounds = true
        backgroundView.backgroundColor = .systemBackground
        shadowView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Asset.dynamicBlack.color
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview().inset(16)
        }
        
        selectedImage = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        selectedImage.alpha = 0
        selectedImage.tag = 10
        backgroundView.addSubview(selectedImage)
        selectedImage.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 28, height: 28))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ConfirmButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        self.backgroundColor = .systemBlue
        
        let titleLabel = UILabel()
        titleLabel.text = "提交"
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.alpha = 0.3
            self.transform = CGAffineTransform.init(scaleX: 0.98, y: 0.98)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
}
