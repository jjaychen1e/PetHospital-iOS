//
//  Department.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import Foundation

struct Equipment: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var position: [Int]
    var picture: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "message"
        case position
        case picture
    }
}

struct Medicine: Codable, Hashable, Identifiable {
    var id: String {
        self.name
    }
    
    var name: String
    var description: String
    var picture: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "message"
        case picture
    }
}

struct Department: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let picture: String
    let roleName: String
    let position: [Int]
    let equipments: [Equipment]
    let medicines: [Medicine]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "message"
        case picture
        case roleName
        case position
        case equipments
        case medicines
    }
}
