//
//  User.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/15.
//

import GRDB

struct LoginParameter: Codable {
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "stuId"
        case password = "pwd"
    }
}

struct LoginResult: Codable {
    var token: String
    var socialUserID: String?
    var user: User
}

struct User: Codable {
    var id: Int
    var username: String
    var password: String
    var userMail: String?
    var nickname: String?
    var avatar: String?
    var location: String?
    var gender: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "stuId"
        case password
        case userMail
        case nickname = "nickName"
        case avatar
        case location
        case gender
    }
}

extension LoginResult: TableRecord {
    static var databaseTableName = "login_result"
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case token
        case socialUserID = "social_user_id"
        case id
        case username
        case password
        case userMail = "user_mail"
        case nickname
        case avatar
        case location
        case gender
    }
}

extension LoginResult: FetchableRecord {
    init(row: Row) {
        token = row[Columns.token]
        socialUserID = row[Columns.socialUserID]
        user = User(id: row[Columns.id],
                    username: row[Columns.username],
                    password: row[Columns.password],
                    userMail: row[Columns.userMail],
                    nickname: row[Columns.nickname],
                    avatar: row[Columns.avatar],
                    location: row[Columns.location],
                    gender: row[Columns.gender])
    }
}

extension LoginResult: PersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container[Columns.token] = token
        container[Columns.socialUserID] = socialUserID
        container[Columns.id] = user.id
        container[Columns.username] = user.username
        container[Columns.password] = user.password
        container[Columns.userMail] = user.userMail
        container[Columns.nickname] = user.nickname
        container[Columns.avatar] = user.avatar
        container[Columns.location] = user.location
        container[Columns.gender] = user.gender
    }
}

struct GoogleUser: Encodable {
    var userID: String
    let source = "google"
    var nickname: String
    var email: String
    var accessToken: String
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "uuid"
        case source
        case nickname = "nickName"
        case email
        case accessToken
        case avatar
    }
}
