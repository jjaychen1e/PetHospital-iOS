//
//  UIViewController+UINavigationBarItem+Extension.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit

extension UIViewController {
    
    func setTransparentNavigationBarWith(backgroundColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
}
