//
//  EndPoint.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import Foundation

let BaseAddress = "http://139.9.217.28:8080"

enum EndPoint: String {
    case register                    = "/oauth/register/all"
    case loginCheck                  = "/oauth/login/check"
    case login                       = "/oauth/login/normal"
    case googleLogin                 = "/oauth/login/app/google"
    
    case allRoles                    = "/simulation/getRoles"
    case allWorkflows                = "/simulation/findProcessByRoleId"
    case workflowSteps               = "/simulation/findStepsByProcessId"
    
    case allDepartments              = "/guide/getDepartments"
    
    case allDiseases                 = "/disease/findAll"
    
    case findDiseaseCase             = "/case/findAll"
    
    case allExams                    = "/exam/findAvailableExams"
    case saveExamResult              = "/exam/saveScore"
    
    case examPaperContent            = "/paper/findPaperById"
    
    var fullEndPointURL: String {
        get {
            BaseAddress + self.rawValue
        }
    }
}
