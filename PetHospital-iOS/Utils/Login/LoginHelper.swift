//
//  LoginHelper.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

class LoginHelper {
    
    static func hasCachedLoginStatus() -> Bool {
        if let loginRestul = try? GRDBHelper.shared.dbQueue.read({ try LoginResult.fetchAll($0) }).first {
            GlobalCache.shared.loginResult = loginRestul
            return true
        }
        
        return false
    }
    
    static func checkLoginStatus(completionHandler: @escaping (Bool) -> ()) {
        completionHandler(true)
//        if let loginResult = try? GRDBHelper.shared.dbQueue.read({ db in
//            try LoginResult.fetchAll(db)
//        }).first {
////            // Check Server
////            if true {
////                completionHandler(true)
////                return
////            } else {
////                completionHandler(false)
////                return
////            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                completionHandler(false)
//            }
//        } else {
//            completionHandler(false)
//        }
    }
    
    static func login(with parameter: LoginParameter, completionHandler: @escaping (Bool) -> ()) {
        NetworkManager.shared.fetch(endPoint: .login, method: .POST, parameters: parameter) { (result: Result<ResultEntity<LoginResult>, Error>) in
            result.resolve { result in
                guard result.code == .success else {
                    print(result)
                    completionHandler(false)
                    return
                }
                
                if let data = result.data {
                    GlobalCache.shared.loginResult = result.data
                    GlobalCache.shared.loginResult = data
                    GlobalCache.shared.loginResult?.user.password = parameter.password
                    do {
                        try GRDBHelper.shared.dbQueue.write { db in
                            try data.save(db)
                        }
                    } catch {
                        print(error)
                    }
                    
                    completionHandler(true)
                    return
                } else {
                    print(result)
                    completionHandler(false)
                    return
                }
            } failureHandler: { error in
                print(error)
                completionHandler(false)
                return
            }
        }
    }
    
    static func googleLogin(with parameter: GoogleUser, completionHandler: @escaping (GoogleLoginResult?) -> ()) {
        NetworkManager.shared.fetch(endPoint: .googleLogin, method: .POST, parameters: parameter) { (result: Result<ResultEntity<GoogleLoginResult>, Error>) in
            result.resolve { result in
                if result.code == .success {
                    if let data = result.data {
                        completionHandler(data)
                        return
                    }
                } else {
                    print(result)
                    completionHandler(nil)
                    return
                }
            } failureHandler: { error in
                print(error)
                completionHandler(nil)
                return
            }
        }
    }
    
}
