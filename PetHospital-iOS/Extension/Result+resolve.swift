//
//  Result+resolve.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/5/2.
//

import Foundation

extension Result {
    func resolve(succeessHandler: (Success) -> Void) {
        resolve(succeessHandler: succeessHandler) { error in
            print(error)
        }
    }
    
    func resolve(succeessHandler: (Success) -> Void, failureHandler: (Failure) -> Void) {
        switch self {
        case .success(let result):
            succeessHandler(result)
        case .failure(let error):
            failureHandler(error)
        }
    }
}
