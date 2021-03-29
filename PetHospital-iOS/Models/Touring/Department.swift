//
//  Department.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import Foundation

struct Equipment: Codable {
    let name: String
    let description: String
    let position: [Int]
    let picture: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "message"
        case position
        case picture
    }
}

struct Department: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let picture: String
    let roleName: String
    let position: [Int]
    let equipments: [Equipment]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "message"
        case picture
        case roleName
        case position
        case equipments
    }
}
