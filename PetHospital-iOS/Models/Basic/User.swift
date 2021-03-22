//
//  User.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/15.
//

struct LoginParameter: Codable {
    var account: AccountType
    var password: String
}

struct User: Codable {
    var token: String
    var userName: String
    var profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case userName = "usrName"
        case profileURL = "profileUrl"
    }
}

enum AccountType: Codable {
    case email(String)
    case phoneNumber(String)
    
    private enum CodingKeys: CodingKey {
        case email
        case phoneNumber
    }
    
    enum AccountTypeCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(String.self, forKey: .email) {
            self = .email(value)
            return
        }
        if let value = try? values.decode(String.self, forKey: .phoneNumber) {
            self = .phoneNumber(value)
            return
        }
        throw AccountTypeCodingError.decoding("Whoops! \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .email(let email):
            try container.encode(email, forKey: .email)
        case .phoneNumber(let phoneNumber):
            try container.encode(phoneNumber, forKey: .phoneNumber)
        }
    }
}
