//
//  LoginHelper.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

class LoginHelper {
    
    static func hasCachedLoginStatus() -> Bool {
        (try? GRDBHelper.shared.dbQueue.read { try User.fetchAll($0) }.count > 0) ?? false
    }
    
    static func checkLoginStatus(completionHandler: @escaping (Bool) -> ()) {
        if let user = try? GRDBHelper.shared.dbQueue.read({ db in
            try User.fetchAll(db)
        }).first {
//            // Check Server
//            if true {
//                completionHandler(true)
//                return
//            } else {
//                completionHandler(false)
//                return
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completionHandler(false)
            }
        } else {
            completionHandler(false)
        }
    }
    
    static func login(with parameter: LoginParameter, completionHandler: @escaping (Bool, String) -> ()) {
        NetworkManager.fetch(endPoint: .login, parameters: parameter) { (result: ResultEntity<User>?) in
            if let result = result {
                guard result.code == .success else {
                    completionHandler(false, "\(result.code). \(result.message).")
                    return
                }
                
                GlobalCache.shared.user = result.data
                completionHandler(true, "\(result.code). \(result.message).")
            } else {
                completionHandler(false, "Decode Error")
            }
        }
    }
    
}
