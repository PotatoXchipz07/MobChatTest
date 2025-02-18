//
//  MessageItem.swift
//  MobChat
//
//  Created by Mac on 27/01/25.
//

import SwiftUI

struct MessageItem: View {
    var message:ChatModel
    @State var time:String = ""

    var body: some View {
        VStack{
            
            HStack(spacing: 0){
                Spacer()
                    .frame(width: 50)
                
                Spacer()
                
                VStack(alignment:.leading){
                    
                    Text(message.msg!)
                        .frame(minWidth: 50)
                        .padding(.top,6)
                        .padding(.bottom,20)
                        .padding(.trailing,20)
                        .padding(.leading,10)
                        .foregroundStyle(.white)
                        .font(.custom("Poppins-Regular", size: 14))

                        .background(){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.messageblue)
                            
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Image(.bluetail)
                                .padding(.trailing,-8)
                            
                        }
                        .overlay(alignment: .bottomTrailing){
                            Text(time)
                                .font(.custom("Montserrat-Bold", size: 8))
                                .padding(.bottom,6)
                                .padding(.trailing,30)
                                .foregroundStyle(Color.white)
                                .lineLimit(1)
                            

                        }
                        .overlay(alignment: .bottomTrailing){
                            Image(.receiveWhite)
                                .font(.custom("Montserrat-Bold", size: 8))
                                .padding(.bottom,6)
                                .padding(.trailing,10)
                                .foregroundStyle(Color.white)
                            
                        }
                    .padding(.leading,20)
                }
            }
            
        }
        
        .onAppear{
            let formmater = DateFormatter()
            formmater.timeZone = TimeZone.current
            formmater.dateFormat = "HH:mm"
            let restore = Date(timeIntervalSince1970: TimeInterval(message.sender_time ?? 0.0))
            time = formmater.string(from: restore)
            
        }
        .padding(.trailing,29.1)
    }

}

#Preview {
    MessageItem(message: ChatModel(msg: "Hii"))
}
