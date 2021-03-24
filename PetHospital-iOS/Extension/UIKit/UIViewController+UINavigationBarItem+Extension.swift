//
//  UIViewController+UINavigationBarItem+Extension.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit

extension UIViewController {
    
    func setTransparentNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Asset.dynamicWhite.color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
}
