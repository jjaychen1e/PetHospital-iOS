//
//  GRDBHelper.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/24.
//

import Foundation
import GRDB

class GRDBHelper {
    let dbQueue: DatabaseQueue!
    
    static var shared = GRDBHelper()
    
    private init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath = documentsPath.appendingPathComponent("db.sqlite")
        dbQueue = try! DatabaseQueue(path: databasePath)
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS user (
                        username TEXT PRIMARY KEY NOT NULL,
                        password TEXT NOT NULL,
                        profile_url TEXT NOT NULL,
                        token TEXT NOT NULL)
                    """)
            }
        } catch {
            fatalError("\(error)")
        }
        
    }
}
