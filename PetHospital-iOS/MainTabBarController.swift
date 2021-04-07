//
//  MainTabBarController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/5.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewControllers?.forEach { $0.view.layoutIfNeeded() }
    }
    
}
