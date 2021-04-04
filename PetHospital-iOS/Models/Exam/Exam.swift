//
//  Exam.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/31.
//

import Foundation

struct Exam: Codable, Hashable {
    var examID: Int
    var paperID: Int
    var examName: String
    var adminID: Int
    var adminName: String
    var startDateTime: String
    var endDateTime: String
    var totalScore: Int
    var questionNumber: Int
    var finished: Bool
    
    enum CodingKeys: String, CodingKey {
        case examID = "examId"
        case paperID = "paperId"
        case examName
        case adminID = "admId"
        case adminName = "admName"
        case startDateTime = "startTime"
        case endDateTime = "endTime"
        case totalScore
        case questionNumber = "questionNums"
        case finished
    }
}
