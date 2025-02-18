//
//  ChatList.swift
//  MobChat
//
//  Created by Mac on 27/01/25.
//

import SwiftUI

struct ChatList: View {
    var data:User
    @EnvironmentObject var viewModal:AuthViewModal
    @State var messages:[ChatModel]? = []
    @State var lastObj:ChatModel? = ChatModel()
    @State var lastmsg:String? = "No Chat"
    @State var i = 0
    @State var noProfile = "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png"
    var body: some View {
        
        HStack{
            if data.profile_image == ""{
                Image(.noProfile)
                    .resizable()
                    .frame(width: 54,height: 54)
                    .clipShape(Circle())
            }
            else{
                AsyncImage(url: URL(string: data.profile_image ?? noProfile))
                    .scaledToFill()
                    .frame(width: 54,height: 54)
                    .clipShape(Circle())
            }

    
 
            VStack(alignment:.leading){
                    Text((data.fistname ?? "Not Found")+" "+(data.lastname ?? "Not Found"))
                        .font(.custom("Montserrat-SemiBold", size: 18))
                        .foregroundStyle(Color.chatblack)

                Text(lastmsg ?? "No Chat")
                        .font(.custom("Montserrat-SemiBold", size: 16))
                        .foregroundStyle(Color.seenGra)
                        .padding(.top,2)
                        .lineLimit(1)
                        .truncationMode(.tail)
            }
            .padding(.leading,16)
        
            .ignoresSafeArea(.all)
        }
        .onAppear{
     

            let chatuid = "\(data.id!)_\(viewModal.currentUserUID)"
            let uidreversed = "\(viewModal.currentUserUID)_\(data.id!)"

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
                    lastObj = messages?.last
                    lastmsg = lastObj?.msg ?? "not found"
                    
                    viewModal.postLastMSG(userid: data.id ?? "", lastMSG: lastmsg ?? "")
    
                }
            }
        }
    }
}

#Preview {
    ChatList(data: User(fistname: "Not Found",lastname: "Not found",profile_image: "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png" ,last_msg: "notFound"))
        .environmentObject(AuthViewModal())
}
