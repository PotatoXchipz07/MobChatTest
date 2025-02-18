//
//  LoginView.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI
import FirebaseAuth
import SwiftData


protocol AuthentitcationFormProtocol{
    var formIsValid:Bool{get}
}
struct LoginView: View {
    
    
    
    
    @EnvironmentObject var viewModal:AuthViewModal

//    @State var rememberme = false
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var isSignIn = false
    @State private var showEmail = false
    @State private var showPassword = false
    @State private var EmailisValid = false
    @State private var PassisValid = false


    
    
    var body: some View {
        NavigationView{
        VStack(spacing:0){
            ZStack{
                Image(.loginTop)
                    .resizable()
//                    .frame(width: .infinity,height: 251)
                

                ZStack {
                    
                    VStack {
                        
                        HStack {
                            Image(.appLogo)
                                .padding(.leading,20)
                                .padding(.top,140)
                                .offset(CGSize(width: 0, height: 30))

                            Spacer()
                        }
                        
                    }
                    
                    
                    
                }
                
                
            }

          
  
            
            
            
            HStack(spacing:0){
                (Text("Login to your\n")
                    .font(Font.custom("Montserrat-Medium", size: 28))+Text("Account")).font(Font.custom("Montserrat-Bold", size: 28))
                    .padding(.leading,24)

                Spacer()
            }
            .padding(.top,50)

            

            HStack{
                Text("Welcome back! Select method to log in")
                    .padding(.leading,24)
                    .font(.custom("Montserrat-Medium", size: 14))
                
                Spacer()
            }
            .padding(.top,15)
            
            VStack(alignment:.leading){
                HStack {
                    Text("Email ID")
                        .font(.custom("Montserrat-Medium", size: 14))
                    Spacer()
                    if showEmail{
                        Text("Email Is \(EmailisValid ? "Valid":"Invalid")")
                            .foregroundStyle(EmailisValid ? .green : .red)
                            .font(.custom("Montserrat-Medium", size: 9))
                    }
                }
                TextField("Enter Your Email ID", text: $email)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.lightblue, lineWidth:1)
                    }
                    .autocapitalization(.none)

            }
            .padding(.top,30)
            .padding(.horizontal,24)
            
            VStack(alignment:.leading){
                HStack {
                    Text("Password")
                        .font(.custom("Montserrat-Medium", size: 14))
                    Spacer()
                    if showPassword{
                        Text("Password Is \(PassisValid ? "Valid":"Invalid")")
                            .foregroundStyle(PassisValid ? .green : .red)
                            .font(.custom("Montserrat-Medium", size: 9))
                    }
                }
                SecureField("Enter Your Password", text: $password)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.lightblue, lineWidth:1)
                    }
                    .autocapitalization(.none)

                


            }
            .padding(.top,15)
            .padding(.horizontal,24)
            
            
            VStack {
                HStack {
                    Image(systemName: viewModal.rememberMe ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(viewModal.rememberMe ? Color(.lightblue2) : Color.secondary)
                        .onTapGesture {
                            self.viewModal.rememberMe.toggle()
                            if viewModal.rememberMe == false {
                                viewModal.userSession = nil
                            }
                        }

                    Text("Remember me.")
                        .font(.custom("Montserrat-Medium", size: 14))
                    Spacer()
                    NavigationLink(destination: ForgetView()) {
                        Text("Forgot password?")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundStyle(.fcolor)
                    }
  
                    
                }
                .padding(.horizontal,24)
                
                
                VStack {


                    if viewModal.showErrorMessage{
                            Text("Please Enter Correct Email and Password !")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundStyle(.white)
                            .padding(.horizontal,10)
                            .padding(.vertical,10)
                            .background(.red)
                            .cornerRadius(30)
                            .opacity(0.8)
                            .lineLimit(1)
                    }


        
                    Button(action: {
                        Task{
                            do{
                                try await viewModal.signIn(withEmail:email,password:password)
                                

//                                viewModal.showErrorMessage = false

                            }catch{
                             
                                print("DEBUG: Failed To User Login \(error.localizedDescription)")
                            }

                        }
                    }, label: {
                        Spacer()
                        Text("Login")
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundStyle(.white)
                        Spacer()
                    })
                    .onChange(of: password, { oldValue, newValue in
                        if password == ""{
                            showPassword = false
                        }else{
                            showPassword = true
                        }
                        
                        PassisValid = isValidPass(newValue)
                    })
                    
                    .onChange(of: email, { oldValue, newValue in
                        if email == ""{
                            showEmail = false
                        }else{
                            showEmail = true
                        }
                        
                        EmailisValid = isValidEmail(newValue)
                    })
                    
                    .padding(.vertical,18)
                    .background(.bcolor)
                    .cornerRadius(60)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .padding(.horizontal,24)
                .padding(.top,49)
                
                HStack{
                    Text("Don’t have account? ").font(.custom("Montserrat-Medium", size: 14))

                    NavigationLink {
                        SignUpView()
                    } label: {
                        
                        Text("Create an account").font(.custom("Montserrat-SemiBold", size: 14)).foregroundStyle(.fcolor)
                    }


                    
                }
                
            }
            .padding(.top,15)
            
            Spacer()
        }
        .ignoresSafeArea()
        
        
        
        }
        
    }
    
    
    func isValidPass(_ password:String)->Bool{
        if password.count > 6{
            return true
        }else{
            return false
        }
    }
    
    func isValidEmail(_ email:String)->Bool{
        let rgx = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return rgx.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
}

extension LoginView:AuthentitcationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && isValidEmail(email)
        && !password.isEmpty
        && isValidPass(password)

        
    }
    
    
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModal())
}
