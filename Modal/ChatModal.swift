//
//  ChatModal.swift
//  MobChat
//
//  Created by Mac on 27/01/25.
//

import Foundation


struct UserAFK:Identifiable,Hashable,Decodable{
    var id = UUID()
    var username:String
//    var messages:String
    var userMessages:[String]
    var image:String
}
