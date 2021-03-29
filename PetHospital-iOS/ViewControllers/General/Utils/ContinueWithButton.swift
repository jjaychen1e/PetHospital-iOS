//
//  ContinueWithButton.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/29.
//

import UIKit

@IBDesignable class ContinueWithButton: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var logoImage: UIImage!
    
    @IBInspectable var continueString: String = "Continue with Something"
    
    @IBInspectable var continueTextColor: UIColor = .white
    
    @IBInspectable var customBackgroundColor: UIColor = .black
    
    var continueFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        self.backgroundColor = customBackgroundColor
        self.tintColor = continueTextColor
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        let continueLabel = UILabel()
        continueLabel.text = continueString
        continueLabel.textColor = self.tintColor
        continueLabel.font = continueFont
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(continueLabel)
    }
}
