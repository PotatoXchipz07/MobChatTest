//
//  MessageItemWhite.swift
//  MobChat
//
//  Created by Mac on 04/02/25.
//

import SwiftUI

struct MessageItemWhite: View {
    var message:ChatModel
    @State var time:String = ""
    var body: some View {
        VStack{

            HStack(spacing:0){

                    Text(message.msg!)
                        .foregroundStyle(.black)
                        .font(.custom("Poppins-Regular", size: 14))
                        .frame(minWidth: 50)
                        .padding(.leading,12)
                        .padding(.top,6)
                        .padding(.bottom,20)
                        .padding(.trailing,20)
                        .background(){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.greyes)
                        }
                        .overlay(alignment: .bottomLeading) {
                            Image(.whitetail)
                                .padding(.leading,-6)
                        }
                        .overlay(alignment: .bottomTrailing){
                            Text(time)
                                .font(.custom("Montserrat-Bold", size: 8))
                                .padding(.bottom,5)
                                .padding(.trailing,30)
                                .foregroundStyle(Color.timershade)
                                .lineLimit(1)
                                
                        }
                        .overlay(alignment: .bottomTrailing){
                            Image(.receiveBlue)
                                .font(.custom("Montserrat-Bold", size: 5))
                                .padding(.bottom,4)
                                .padding(.trailing,10)
                                .foregroundStyle(Color.timershade)
                        }
                    


      
                .padding(.trailing,20)
                Spacer()
                    .frame(width: 50)
                Spacer()
            }
            
               
        }
        .onAppear{
            let formmater = DateFormatter()
            formmater.timeZone = TimeZone.current
            formmater.dateFormat = "HH:mm"
            let restore = Date(timeIntervalSince1970: TimeInterval(message.sender_time ?? 0.0))
            time = formmater.string(from: restore)
            
        }
        .padding(.leading,29.1)
    }
}

#Preview {
    MessageItemWhite(message: ChatModel(msg: "Hii"))
}
