//
//  WorkflowStep.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/7.
//

import Foundation

struct WorkflowStep: Codable {
    var name: String
    var description: String
    var picture: String?
    var video: String?
    
    enum CokindingKeys: String, CodingKey {
        case name
        case description = "message"
        case picture
        case video
    }
}
