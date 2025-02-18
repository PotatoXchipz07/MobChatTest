//
//  ChatView.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI

struct ChatView: View {

    @EnvironmentObject var viewModal:AuthViewModal
    
    
    @EnvironmentObject var firebaseviewModal:FirebaseModal
//    @State var datalistArraz:[Data]?
    @State var usersData:[User]?
    @State var usersMessages:[ChatModel]?
    @State private var search:String = ""
    @AppStorage("userUID") var userUID = ""
    
    
    
    var body: some View {
        NavigationView{
            

        ZStack{

            Color(.backG)
                .ignoresSafeArea()
            

            
            VStack{
                HStack {
                    Text("Chats")
                        .font(.custom("Montserrat-Bold", size: 32))
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {
                        viewModal.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    })



//                    Button(action: {
//                        viewModal.signOut()
//                    }, label: {
//                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
//                    })

                    
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(.edit)
                    }

                 
                }
                .padding(.horizontal,24)
                Spacer()
                
                
                
                
            }
            .onAppear{


            }
            
            
            ZStack{
                Image(.background)
                    .resizable()
                    .ignoresSafeArea()
                
                
                VStack{
                    
                    HStack {
                        
                        Image(systemName: "magnifyingglass")
                            .padding(.leading,16)
                        TextField("Search", text: $search)
                            .padding()
                        
       
                        }
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.lightblue, lineWidth:1)
                    }
                    .padding(.horizontal,24)

             
                    List {
            
                        ForEach(usersData?.sorted(by: {
                            print("Acitve TimeStamp $0 :\($0.last_Active ?? 0)")
                            print("Acitve TimeStamp $1 :\($1.last_Active ?? 0)")
                            return $0.last_Active ?? 0 > $1.last_Active ?? 0
                        }) ?? [],id: \.self){ data in
                            if data.id != viewModal.currentUserUID{
                                
                                ZStack {
                                    NavigationLink(destination: UserChatMView(user: data)) {
                                        
                                        ChatList(data: data)
                                    }
                                    
                                }
                                .foregroundStyle(Color.clear) /// uRemember
                                .listRowBackground(Color.chatwhite)
                                .padding(.vertical,11.0)
                                .listRowSpacing(10)
                                .listStyle(.plain)
                            }
             

                            
                            
                        }
       

                        
                    }
                    .onAppear{
                        viewModal.fetchAllUser {
                            
                            usersData = viewModal.fetchUserObj
                            
                        }
                    }

                    .listStyle(PlainListStyle())
                      
  
   

                    
                    Spacer()
                    

                }

                .padding(.top,20)
                
     
            }
            
            .padding(.top,70)
            .edgesIgnoringSafeArea(.bottom)
            }
        .onAppear{
//            viewModal.FetchAllMessages {
//                usersMessages = viewModal.fetchChatObj
//            }

        }
        }
        .onAppear{
            
//            viewModal.fetchUserDetail {
//                firstname = viewModal.object?.fistname ?? ""
//                lastname = viewModal.object?.lastname ?? ""
//
//            }
            if viewModal.currentUserUID == ""{
                viewModal.currentUserUID = userUID
            }else{
                userUID = viewModal.currentUserUID
            }




   
        }
        .navigationBarBackButtonHidden()

    }
        
}

#Preview {
    ChatView()
        .environmentObject(AuthViewModal())
//        .environmentObject(FirebaseModal())
}
