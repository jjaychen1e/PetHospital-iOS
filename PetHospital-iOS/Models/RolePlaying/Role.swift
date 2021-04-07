//
//  Role.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import Foundation

struct Role: Codable, Identifiable {
    var id: Int
    var name: String
    var picture: String
    var description: String = "我们还需要角色的描述信息，后端暂时没有这个字段。"
    
    var emoji: String {
        switch name {
        case "医生", "医师":
            return "👨‍⚕️"
        case "医助":
            return "👩‍⚕️"
        case "前台":
            return "💁"
        default:
            return "👨🏻"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
        case description = "message"
    }
}
