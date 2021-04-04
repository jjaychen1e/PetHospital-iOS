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
    var cases: [DiseaseCase]?
    
    enum CodingKeys: String, CodingKey {
        case diseaseID = "diseaseId"
        case name
        case children
    }
}

struct DiseaseCase: Codable, Hashable {
    var caseID: Int
    var name: String
    var inspection: String
    var diagnosis: String
    var treatment: String
    var createTime: String
    var updateTime: String
    
    enum CodingKeys: String, CodingKey {
        case caseID = "caseId"
        case name
        case inspection
        case diagnosis
        case treatment
        case createTime
        case updateTime
    }
}

struct DiseaseCaseResult: Codable, Hashable {
    var content: [DiseaseCase]
}
