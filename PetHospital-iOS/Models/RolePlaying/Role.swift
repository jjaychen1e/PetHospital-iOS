//
//  Role.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import Foundation

struct Role: Codable, Identifiable {
    var id = UUID()
    
    var name: String
    var description: String
    
    var emoji: String {
        switch name {
        case "医生":
            return "👨‍⚕️"
        case "医助":
            return "👩‍⚕️"
        case "前台":
            return "💁"
        default:
            return "👨🏻"
        }
    }
}
