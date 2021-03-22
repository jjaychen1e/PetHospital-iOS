//
//  LoginHelper.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

class LoginHelper {
    
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
