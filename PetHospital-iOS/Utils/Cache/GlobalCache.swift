//
//  GlobalCache.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

class GlobalCache {
    
    var user: User?
    
    var token: String? {
        user?.token
    }
    
    static let shared: GlobalCache = {
        let shared = GlobalCache()
        // do other works here..
        
        return shared
    }()
    
    private init() {
        
    }
    
}
