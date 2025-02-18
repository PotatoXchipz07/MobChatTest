//
//  UserChatMView.swift
//  MobChat
//
//  Created by Mac on 27/01/25.
//

import SwiftUI
import FirebaseAuth
import SwiftUI
import SwiftData
import FirebaseDatabase
import FirebaseDatabaseInternal

struct UserChatMView: View {
    @State private var sendTf = ""
    @EnvironmentObject var viewModal:AuthViewModal
    var user:User
    @State var messages:[ChatModel]? = []
    @State var lastObj:ChatModel? = ChatModel()
    @State var filtermessages:[ChatModel]? = []
//    @State var time:String = ""
    @State var userName = ""
    @State var firstname = ""
    @State var lastname = ""
    @State var lastmsg = ""
    @State private var showSendButton = false
//    @State var timestamp = date.timeIntervalSince1970
    
    var body: some View {
        VStack(){
            
            GeometryReader(content: { geometry in
                ScrollView{
                    ScrollViewReader(){ scrollview in
                        Spacer()
                        
                        ForEach(messages ?? [],id: \.self){ data in
                            
                            if data.sender_id == user.id{
//                                print(data.msg?.last ?? "not work")
                                MessageItemWhite(message: data)
                                    .padding(.vertical,5)
                            }
                            else{
                                MessageItem(message: data)
                                    .padding(.vertical,5)
                            }
                        }
                    }

                    .frame(minHeight: geometry.size.height)
                }
                .defaultScrollAnchor(.bottom)
            })
            .padding(.bottom,10)
//            .background(.blue)
            .background(Color.whiteback)

            
            
            
            
            VStack{
                HStack {
                    
                    HStack {
                        Button(action: {}, label: {
                            Image(.emoji)
                                .padding(.leading,15)
                        })
                        TextField("Type message..", text: $sendTf)
                            .padding(.vertical,18)
                            .font(.custom("", size: 16))
                    }
                    .background(.whitetf)
                    .cornerRadius(43)
                    .textFieldStyle(.plain)
                    .padding(.leading,24)

                    
                    HStack {
                        Button(action: {}, label: {
                            Image(.icShedualMessage)
                        })
                        Button(action: {}, label: {
                            Image(.icCamera)
                        })
                        Button(action: {
//                            print(timestamp)
                                viewModal.postMessage(
                                    
                                    chatid:"\(viewModal.currentUserUID)\(user.id!)",
                                    msg: sendTf,receiver_id: user.id!,
                                    receiver_name: "\(user.fistname!) \(user.lastname!)",
                                    sender_id: viewModal.currentUserUID, sender_name: userName)
                                
                                sendTf = ""
                            
                            lastObj = messages?.last
                            lastmsg = lastObj?.msg ?? "not found"
                            
                            viewModal.postLastMSG(userid: user.id ?? "", lastMSG: lastmsg)
                         }, label: {
                            Image(.send)
                                .resizable()
                                .frame(width: 25,height: 25)
                        })
                        .onChange(of: sendTf) {
                            if sendTf == ""{
                                showSendButton = false
                            }else{
                                showSendButton = true
                            }
                        }
                        .disabled(!showSendButton)
                        .opacity(showSendButton ? 1.0 : 0.5)
               
        
                 
                        
                    }
                    .padding(.trailing,24)
                    
                    
  
                }

            }
            .padding(.top,10)

                .font(.custom("Montserrat-Bold", size: 32))
                .navigationBarItems(leading:
                                        
                                        AsyncImage(url: URL(string: user.profile_image!))
                        //                    .resizable()
                    .scaledToFit()
                                            .frame(width: 35,height: 35)
                                            .clipShape(Circle())
                   
                  
                
                
                )
            
                .navigationTitle("\(user.fistname ?? "Not Found") \(user.lastname ?? "Not Found")")
        }
        .onAppear{

            viewModal.fetchUserDetail {
                firstname = viewModal.object?.fistname ?? ""
                lastname = viewModal.object?.lastname ?? ""
                userName = firstname+" "+lastname
            }
            
            let chatuid = "\(user.id!)_\(viewModal.currentUserUID)"
            let uidreversed = "\(viewModal.currentUserUID)_\(user.id!)"

            viewModal.currentChatUID = chatuid
            
            viewModal.fetchAllMessages(for: chatuid,for: uidreversed) { fetchMessage, error in
                if error != nil{
                    print("Failed to Fetch Data")
                }else if let fetchMessage = fetchMessage{
                    messages = fetchMessage
                    messages = messages?.sorted(by: {
                        print("TimeStamp $0 :\($0.sender_time ?? 0)")
                        print("TimeStamp $1 :\($1.sender_time ?? 0)")
                        return $0.sender_time ?? 0 < $1.sender_time ?? 0
                    })

                }
            }
        }

    }
}
extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
#Preview {
    UserChatMView(user: User(id: "",fistname: "",lastname: "",phone: "",profile_set: false,profile_image: ""))
        .environmentObject(AuthViewModal())
}
