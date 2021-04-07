//
//  WorkflowStep.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/7.
//

import Foundation

struct WorkflowStep: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var picture: String?
    var video: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "message"
        case picture
        case video
    }
}
