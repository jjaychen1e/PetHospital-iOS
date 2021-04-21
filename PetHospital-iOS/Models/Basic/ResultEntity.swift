//
//  ResultEntity.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/15.
//

struct ResultEntity<T: Codable>: Codable {
    let code: ResultCode
    let message: String?
    let data: T?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
        case data
    }
}

//https://github.com/Onion12138/petHospital/wiki/API
enum ResultCode: Int, Codable {
    case failed               = -1
    case success              = 200
    case parseError           = 301
    case authenticationFailed = 302
    case invalidParameter     = 303
    case internalError        = 500
}

