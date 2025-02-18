//
//  AuthViewModal.swift
//  MobChat
//
//  Created by Mac on 28/01/25.
//

import Foundation
import FirebaseAuth
import SwiftUI
import SwiftData
import FirebaseDatabase
import FirebaseDatabaseInternal


@MainActor
class AuthViewModal:ObservableObject{
    
    private let ref = Database.database().reference()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var rememberMe = false
    @Published var showErrorMessage = false
    @Published var showErrorMessageRegister = false
    @Published var i = 0

    var currentUserUID = ""
    var currentUserName = ""
    var currentChatUID = ""
    
    var dataChatUID = ""
    
    @Published var object:User? = User()
    @Published var fetchUser:User? = nil
    
    @Published var fetchUserObj = [User]()
    var messages:[ChatModel] = []
    
    @Published var fetchChatObj = [ChatModel]()
    @Published var userUid:[String] = []
    @Published var value:String? = nil
    @Published var data:ChatModel? = nil
    @Published var datalist:[ChatModel]?
    
    
    init(){
        self.userSession = Auth.auth().currentUser
    }
    
    func createUser(withEmail email:String,password:String,firstname:String,lastname:String,phone:String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid,email: email, fistname: firstname,lastname: lastname,phone: phone)
            try await ref.child("users").child(user.id ?? "").setValue(user.toDictory)
            currentUserUID = result.user.uid
            
            
            
        }catch{
            showErrorMessageRegister = true
            print("DEBUG: Failed to Create Account \(error.localizedDescription)")
        }
    }
    
    func signIn(withEmail email:String,password:String) async throws{
        
        
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            currentUserUID = result.user.uid
            currentUserName = result.user.displayName ?? "No data found"
            
            
        }catch{
            showErrorMessage = true
            print("DEBUG: Failed To User Login \(error.localizedDescription)")
        }
        
    }
    
    func fetchUserDetail(completion: @escaping ()->Void ) {
        ref.child("users").child(currentUserUID).getData(completion: { error, datasnapshort in
            if let datasnapshort{
                do{
//                    print(datasnapshort.value!)
                    try self.object = datasnapshort.data(as: User.self)
                    self.currentUserName = "\(self.object?.fistname! ?? "")  \(self.object?.lastname!  ?? "")"
                    
                    completion()
                }catch{
                    print("Cant Convert Your Data \(error)")
                }
            }
        })
    }
    
    func fetchUserInfo() {
        ref.child("users").child(currentUserUID).getData(completion: { error, datasnapshort in
            if let datasnapshort{
                do{
//                    print(datasnapshort.value!)
                    try self.object = datasnapshort.data(as: User.self)
                    self.currentUserName = "\(self.object?.fistname! ?? "")  \(self.object?.lastname!  ?? "")"
                    
                }catch{
                    print("Cant Convert Your Data \(error)")
                }
            }
        })
    }
    
    
    func fetchAllUser(compilation:@escaping ()->Void){
        ref.child("users").getData { error, snapshort in
            if let error = error{
                print("Failed: \(error)")
            }
            guard let value = snapshort?.value as? [String:Any] else{
                print("DEBUG: Data not Found:\(String(describing: error?.localizedDescription))")
                return
            }
//            print(value)
            self.fetchUserObj.removeAll()
            for (userID,userData) in value{
                if let userDic = userData as? [String:Any]{
                    let firstname = userDic["fistname"] as? String ?? "Not Found"
                    let lastname = userDic["lastname"] as? String ?? "Not Found"
                    let email = userDic["email"] as? String ?? "Not Found"
                    let last_msg = userDic["last_msg"] as? String ?? "Not Found"
                    let lastAcitve = userDic["last_Active"] as? Double ?? 0.0
                    let profile_image = userDic["profile_image"] as? String ?? "0.0"
                    
                    let users = User(id: userID,email:email,fistname: firstname,lastname: lastname,profile_image: profile_image, last_msg: last_msg,last_Active: lastAcitve)
                    self.fetchUserObj.append(users)
//                    print(self.fetchUserObj)

                    compilation()
                }
            }

        }
    }
    
    func fetchAllMessages(for userUIDF:String,for reversed:String,compilation: @escaping ([ChatModel]?,Error?) -> Void){
        //        dataChatUID = userUIDF
        //        ref.child("chats").child(dataChatUID).child("messages").observe(.value) { snapshort in
        //
        //            if snapshort.exists(){
        //                print("Path is exist!")
        //                self.dataChatUID = userUIDF
        //                return
        //            }else{
        //                print("Path is Reversed")
        //                self.dataChatUID = reversed
        //                return
        //            }
        //
        //        }
        
        ref.child("chats").child(userUIDF).child("messages").observe(.value) { snapshort in
            
            if !snapshort.exists(){
                print("Path is Incorrect!:")
                return
            }
            
            guard let value = snapshort.value as? [String:Any] else {
                print("Failed to Get Value:")
                return
            }
            
//            print("snapshort.value \(value)")
            self.messages.removeAll()
            
            for (_,messageData) in value{
                //                if userUIDF == self.currentUserUID{
                //
                //                }
                if let messageDic = messageData as? [String:Any]{
                    let message = ChatModel(
                        sender_time: messageDic["sender_time"] as? Double,
                        isread: messageDic["isread"] as? Bool,
                        msg: messageDic["msg"] as? String,
                        receiver_id: messageDic["receiver_id"] as? String,
                        receiver_name: messageDic["receiver_name"] as? String,
                        sender_id: messageDic["sender_id"] as? String,
                        sender_name: messageDic["sender_name"] as? String,
                        user_Profile: messageDic["user_Profile"] as? String
                    )
                    for message in self.messages{
                        print(message)
                    }
//                    self.messages.sort{ $0.sender_time ?? 0.0  < $1.sender_time ?? 0.0 }
                    
                    for message in self.messages{
                        print(message)
                    }
                    self.messages.append(message)
                }
            }
            
      
            compilation(self.messages,nil)
            
        }
        
        
        
        ref.child("chats").child(reversed).child("messages").observe(.value) { snapshort in
            
            if !snapshort.exists(){
                print("Path is Incorrect!: in reversed")
                return
            }
            
            guard let value = snapshort.value as? [String:Any] else {
                print("Failed to Get Value:")
                return
            }
            
//            print("snapshort.value \(value)")
            self.messages.removeAll()
            
            for (_,messageData) in value{
                //                if userUIDF == self.currentUserUID{
                //
                //                }
                if let messageDic = messageData as? [String:Any]{
                    let message = ChatModel(
                        sender_time: messageDic["sender_time"] as? Double,
                        isread: messageDic["isread"] as? Bool,
                        msg: messageDic["msg"] as? String,
                        receiver_id: messageDic["receiver_id"] as? String,
                        receiver_name: messageDic["receiver_name"] as? String,
                        sender_id: messageDic["sender_id"] as? String,
                        sender_name: messageDic["sender_name"] as? String,
                        user_Profile: messageDic["user_Profile"] as? String
                    )
//                    self.messages = self.messages.sorted(by: { $0.sender_time ?? 0.0 < $1.sender_time ?? 0.0 })
//                    print("Sequence:\(message.msg!)")

                    self.messages.append(message)
                }
            }
      
            compilation(self.messages,nil)
            
        }
        
    }
    
    func postLastMSG(userid:String,lastMSG:String){
        let date = Date()
        let timestamp = date.timeIntervalSince1970
        
        ref.child("users/\(userid)/last_msg").setValue(lastMSG)

        ref.child("users/\(userid)/last_Active").setValue(timestamp)
       
    }
    
    func updateProfileDetial(firstname:String,lastname:String,email:String,phone:String,profile_image:String){
//        let date = Date()
//        let timestamp = date.timeIntervalSince1970
        
//        let user = User(id:currentUserUID,email: email,fistname: firstname,lastname: lastname,phone: phone,profile_image: profile_image)
//        ref.child("users").child(currentUserUID).setValue(user.toDictory)
//        print(user)
//        
        
        ref.child("users/\(currentUserUID)/fistname").setValue(firstname)
        ref.child("users/\(currentUserUID)/lastname").setValue(lastname)
        ref.child("users/\(currentUserUID)/email").setValue(email)
        ref.child("users/\(currentUserUID)/phone").setValue(phone)
        ref.child("users/\(currentUserUID)/profile_image").setValue(profile_image)
    }
    
    func postMessage(chatid:String,msg:String,receiver_id:String,receiver_name:String,sender_id:String,sender_name:String){
        let date = Date()
        let timestamp = date.timeIntervalSince1970
        
        
        let chatid1 = "\(sender_id)_\(receiver_id)"
        let chatid2 = "\(receiver_id)_\(sender_id)"
        
        
        ref.child("chats").child(chatid1).child("messages").observeSingleEvent(of:.value) { snapshort1 in
            if snapshort1.exists(){
                
                let message = ChatModel(
                    sender_time: timestamp,
                    msg:msg,
                    receiver_id: receiver_id,
                    receiver_name:receiver_name,
                    sender_id:sender_id,
                    sender_name:sender_name
                )
                
                
                self.ref.child("chats").child(chatid1).child("messages").childByAutoId().setValue(message.toDictory)
                return
            }else{
                
                self.ref.child("chats").child(chatid2).child("messages").observeSingleEvent(of:.value) { snapshort2 in
                    if snapshort2.exists(){
                        
                        let message = ChatModel(
                            sender_time: timestamp,
                            msg:msg,
                            receiver_id: receiver_id,
                            receiver_name:receiver_name,
                            sender_id:sender_id,
                            sender_name:sender_name
                        )
                        
                        self.ref.child("chats").child(chatid2).child("messages").childByAutoId().setValue(message.toDictory)

                       
     
                    }else{
                        
                        let message = ChatModel(
                            sender_time: timestamp,
                            msg:msg,
                            receiver_id: receiver_id,
                            receiver_name:receiver_name,
                            sender_id:sender_id,
                            sender_name:sender_name
                        )
                        self.ref.child("chats").child(chatid1).child("messages").childByAutoId().setValue(message.toDictory)
                    }
                    
                }
            }
            
        }

            
            
            
        
        
    }
        
        func signOut(){
            do{
                try Auth.auth().signOut()
                userSession = nil
                currentUser = nil
            }catch{
                print("DEBUG: Failed to LogOUT!\(error.localizedDescription)")
            }
        }
        
        
        
        //    func fetchAllMessages(uid:String,i:Int,compilation:@escaping ()->Void){
        //
        //
        //        ref.child("chats").child(currentUserUID+uid).child("messages").getData { error, snapshort in
        //            if let error = error{
        //                print("Failed: \(error)")
        //            }
        //            guard let value = snapshort?.value as? [String:Any] else{
        //                print("DEBUG: Data not Found:\(String(describing: error?.localizedDescription))")
        //                return
        //            }
        //
        //            for (userID,userData) in value {
        //                if let dataDic = userData as? [String:Any]{
        //                    let msg = dataDic["msg"] as? String
        //                    let receiver_id = dataDic["receiver_id"] as? String
        //                    let sender_id = dataDic["sender_id"] as? String
        //                    let sender_name = dataDic["sender_name"] as? String
        //                    let receiver_name = dataDic["receiver_name"] as? String
        //                    let chatObj = ChatModel(receiver_id: receiver_id,receiver_name: receiver_name,sender_id: sender_id,sender_name: sender_name)
        //                    compilation()
        //                }
        //            }
        //
        ////            ForEach(self.fetchUserObj.unsafelyUnwrapped,id: \.self){ data in
        ////                print(data.fistname+" "+data.email)
        ////            }
        //
        //
        //
        //        }
        //
        //
        //    }
        
        //    func getOtherUser(complition:@escaping ()->Void){
        //
        //        ref.child("users").observeSingleEvent(of:.value) { snapshot in
        //            self.value = snapshot.value as? String
        //        }
        //
        //
        //        ref.child("users").getData(completion: { error, datasnapshort in
        //            if let datasnapshort{
        //                do{
        //                    print(datasnapshort.v)
        //                    try self.listuser = datasnapshort.data(as: [User].self)
        //                }catch{
        //                    print("DEBUG:Failed to Convert:\(error)")
        //                }
        //            }
        //        })
        //    }
        //    func getChatObjectArray(complition:@escaping ()->Void){
        //        ref.child("chats").child("6qZ0SmOnwVhzunOhTOKGTkkGLFC29JH1RefWaMQnBbZ7fzOtE3kuN5t2").child("messages").observe(.value) { parentchildren in
        //            guard let children = parentchildren.children.allObjects as? [DataSnapshot] else{
        //                return
        //            }
        //
        //            self.datalist = children.compactMap({ snapshot in
        //                return try? snapshot.data(as: Data.self)
        //                complition()
        //            })
        //        }
        //    }
        
        //    func getUserMember(){
        //    ref.child("chats").observe(.value) { snapshot in
        //                    self.value = snapshot.value as? String
        //                    print(self.value ?? "Something Else")
        //                }
        //    }
        
        
        
        
        
        //    func fetch() async{
        //        guard let uid = Auth.auth().currentUser?.uid else{return}
        //        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        //        self.currentUser = try? snapshot.data(as: User.self)
        
        //        print("DEBUG: Data:\(String(describing: currentUser.self))")
        //    }
        
        
        //            var useruid = UserSession(id: UUID().uuidString, lastlogin:userUID)
        //            modelContext.insert(useruid)
        //
        //            var uid:UserSession?{swiftData.last}
        //            userUID = uid?.lastlogin ?? "NO Data"// dummy
        
        //            var useruid = User(id: UUID(), userUid: "\(result.user.uid)")
        //            modelContext.insert(useruid)
        //
        //            var uid:UserUid?{userUIDData.last}
        //            userUID = uid!.userUid
        //            print(uid)
        
        //    func getChatData(uid:String,i:Int,complition:@escaping ()->Void){
        //        ref.child("chats").child(currentUserUID+uid).child("messages").getData(completion: { error, datasnapshort in
        //            if let datasnapshort {
        //                do{
        //                    print(datasnapshort.value)
        //                    try self.datalist = datasnapshort.data(as: [ChatModel].self)
        //                    complition()
        //                }catch{
        //                    print("Cant Convert Your Data \(error)")
        //                }
        //            }
        //        })
        //    }
  
}
