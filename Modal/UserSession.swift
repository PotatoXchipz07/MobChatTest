//
//  UserUid.swift
//  MobChat
//
//  Created by Mac on 30/01/25.
//

import Foundation
import SwiftData

@Model
class UserSession{
    var id:UUID
    var lastlogin:String
    
    init(id: UUID, lastlogin: String) {
        self.id = id
        self.lastlogin = lastlogin
    }
}
