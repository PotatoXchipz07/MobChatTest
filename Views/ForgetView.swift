//
//  LoginView.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI

struct ForgetView: View {
    
    @Environment (\.presentationMode) var presentationMode
    @State private var email:String = ""
    
    var body: some View {
        VStack(spacing:0){
            ZStack {
                Image(.forgotPasswordTop)
                    .resizable()
                
                VStack{
                    HStack {
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(.back)
                                .resizable()
                            .frame(width: 24,height: 30)
                        })
    
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top,69)
                .padding(.horizontal,24)
            }
       



            HStack{
                (Text("Forgot\n")
                    .font(Font.custom("Montserrat-Medium", size: 28))+Text("Password?")).font(Font.custom("Montserrat-Bold", size: 24))
            

                Spacer()
            }
            .padding(.leading,24)
            .padding(.top,27)
            
            VStack {
                Text("Don’t worry! It happens. Please enter the ddress associated with your account.")
                    .font(Font.custom("Montserrat-Medium", size: 15))
                    .foregroundStyle(.descrip)
            }
            .padding(.top,15)
            .padding(.leading,18)
            
            
            VStack(alignment:.leading){
                Text("Email ID")
                    .font(.custom("Montserrat-Medium", size: 14))
                TextField("Enter Your Email Id", text: $email)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.lightblue, lineWidth:1)
                    }
            }
            .padding(.top,30)
            .padding(.horizontal,24)
            


            
            
            VStack {

                
                
                VStack {
                    Button(action: {}, label: {
                        Spacer()
                        Text("Forgot Password")
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundStyle(.white)

                        Spacer()

                    })
                    .padding(.vertical,18)
                    .background(.bcolor)
                    .cornerRadius(60)
                }
                .padding(.horizontal,24)
                .padding(.top,26)
                
                (Text("Already have an account? ").font(.custom("Montserrat-Medium", size: 14))+Text("Login").font(.custom("Montserrat-SemiBold", size: 14)).foregroundStyle(.fcolor))
                    .padding(.top,15)
            }
            .padding(.top,30)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        
        
        
    }
    
}

#Preview {
    ForgetView()
}
