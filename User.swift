//
//  User.swift
//  MobChat
//
//  Created by Mac on 28/01/25.
//

import Foundation

struct User:Hashable,Decodable,Encodable{
    
    var id: String? = ""
    var email:String? = ""
    var fistname:String? = ""
    var lastname:String? = ""
    var phone:String? = ""
    var created_time_stamp:String? = ""
    var profile_set:Bool? = false
    var profile_image:String? = ""
    var last_msg:String? = ""
    var last_Active:Double? = 0.0
    
//    var chat:[ChatModel]?

    static func < (lhs: User, rhs: User) -> Bool {
        lhs.last_Active! > rhs.last_Active!
    }
    
}
struct ChatModel:Hashable,Decodable,Encodable,Comparable{

    
    var id: String? = nil
    var sender_time:Double? = 0.0
    var isread:Bool? = false
    var msg:String? = ""
    var receiver_id:String? = ""
    var receiver_name:String? = ""
    var sender_id:String? = ""
    var sender_name:String? = ""
    var user_Profile:String? = ""
    
    
    static func < (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.sender_time! > rhs.sender_time!
    }
}

//struct Chat:Hashable,Decodable{
//    var memberId:UUID
//    var message:[Message]
//    
//
//}
//struct Message:Hashable,Decodable{
//    var index:[Int]
//    var data:[Data]
//    
//
//}
//


extension Encodable{
    var toDictory:[String: Any]?{
        guard let data = try? JSONEncoder().encode(self)else{
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
    }
}
