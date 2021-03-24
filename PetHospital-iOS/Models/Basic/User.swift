//
//  User.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/15.
//

import GRDB

struct LoginParameter: Codable {
    var account: AccountType
    var password: String
}

struct User: Codable {
    var username: String
    var password: String = ""
    var profileURL: String
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case profileURL = "profileUrl"
        case token
    }
}

extension User: TableRecord {
    /// The table columns
    enum Columns: String, ColumnExpression {
        case username, password, profileURL = "profile_url", token
    }
}

extension User: FetchableRecord {
    init(row: Row) {
        username = row[Columns.username]
        password = row[Columns.password]
        profileURL = row[Columns.profileURL]
        token = row[Columns.token]
    }
}

extension User: PersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container[Columns.username] = username
        container[Columns.password] = password
        container[Columns.profileURL] = profileURL
        container[Columns.token] = token
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
