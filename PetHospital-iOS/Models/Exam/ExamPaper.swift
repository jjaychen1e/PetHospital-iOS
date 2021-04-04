//
//  ExamPaper.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/3.
//

import Foundation

struct ExamPaper: Codable {
    var paperID: Int
    var paperName: String
    var duration: Int
    var questions: [ExamQuestion]
    
    enum CodingKeys: String, CodingKey {
        case paperID = "paperId"
        case paperName
        case duration
        case questions
    }
}

struct ExamQuestion: Codable {
    var questionID: Int
    var stem: String
    var choices: [String]
    var answer: ExamQuestionChoice
    var score: Int
    var selectedChoice: ExamQuestionChoice?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case stem
        case choices
        case answer
        case score
    }
}

enum ExamQuestionChoice: String, Codable {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    
    static func convert(choiceIndex: Int) -> Self {
        switch choiceIndex {
        case 0:
            return .A
        case 1:
            return .B
        case 2:
            return .C
        case 3:
            return .D
        case 4:
            return .E
        case 5:
            return .F
        case 6:
            return .G
        case 7:
            return .H
        case 8:
            return .I
        case 9:
            return .J
        case 10:
            return .K
        default:
            return .A
        }
    }
}
