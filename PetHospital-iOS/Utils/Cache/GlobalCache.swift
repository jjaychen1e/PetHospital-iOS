//
//  GlobalCache.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation
import UIKit

class GlobalCache {
    
    var loginResult: LoginResult?
    
    var token: String? {
        loginResult?.token
    }
    
    static let shared: GlobalCache = {
        let shared = GlobalCache()
        // do other works here..
        
        return shared
    }()
    
    private init() {
        
    }
    
    @objc func clearLoginCache() {
        do {
            try GRDBHelper.shared.dbQueue.write { db in
                try GlobalCache.shared.loginResult?.delete(db)
            }
            
            if let nvc = (UIApplication.shared.delegate as! AppDelegate).rootNavigationController {
                nvc.setNavigationBarHidden(false, animated: false)
                nvc.setViewControllers([StoryboardScene.Login.initialScene.instantiate()], animated: true)
            }
        } catch {
            print(error)
        }
    }
    
}
