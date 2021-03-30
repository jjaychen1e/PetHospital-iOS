//
//  EndPoint.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

let BaseAddress = "http://localhost:8080"

enum EndPoint: String {
    case register                    = "/oauth/register/all"
    case loginCheck                  = "/oauth/login/check"
    case login                       = "/oauth/login/normal"
    case googleLogin                 = "/oauth/login/app/google"
    case departmentInfo              = "/usr/getLayout"
    
    var fullEndPointURL: String {
        get {
            BaseAddress + self.rawValue
        }
    }
}
