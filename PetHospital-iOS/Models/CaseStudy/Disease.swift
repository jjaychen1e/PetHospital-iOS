//
//  Disease.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/30.
//

struct Disease: Codable, Hashable {
    var diseaseID: Int
    var name: String
    var children: [Disease]?
    
    enum CodingKeys: String, CodingKey {
        case diseaseID = "diseaseId"
        case name
        case children
    }
}
