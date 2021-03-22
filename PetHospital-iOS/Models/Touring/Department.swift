//
//  Department.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import Foundation

struct Department: Codable, Identifiable {
    var id = UUID()
    
    var name: String
    var thumbnail: String
}
