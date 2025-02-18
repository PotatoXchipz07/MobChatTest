//
//  LoginView.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI
import Firebase
//import FirebaseCore
struct SignUpView: View {
//    var authManager:AuthManager
    init() {
       UIScrollView.appearance().bounces = false
    }
    
    @EnvironmentObject var viewModal:AuthViewModal

    @Environment (\.presentationMode) var presentationMode
    @State var policy = false
    @State private var firstname:String = ""
    @State private var lastname:String = ""

    @State private var email:String = ""
    @State private var phone:String = ""
    @State private var password:String = ""
    @State private var repassword:String = ""
    @State private var showEmail = false
    @State private var showPhone = false
    @State private var showPassword = false
    @State private var showRePassword = false
    @State private var reshowPassword = false
    @State private var EmailisValid = false
    @State private var PhoneisValid = false
    @State private var PassisValid = false
    @State private var RePassisValid = false
    var body: some View {
        ScrollView{
            VStack(spacing:0){
                ZStack{
                    Image(.signUpTop)
                        .resizable()
//                        .frame(width: .infinity,height: 251)
                    
                    ZStack {
                        
                        VStack {
                            
                            HStack {
                                Image(.appLogo)
                                    .resizable()
                                    .frame(width: 60,height: 60)
                                    .padding(.leading,20)
                                    .padding(.top,70)

                                Spacer()
                            }
                            
                            HStack(spacing:0){
                                (Text("Create your\n")
                                    .font(Font.custom("Montserrat-Medium", size: 28))+Text("Account")).font(Font.custom("Montserrat-Bold", size: 24))
                                    .padding(.leading,24)

                                Spacer()
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }



                
                HStack{
                    VStack(alignment:.leading){
                        Text("First Name")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        HStack{
                            TextField("Enter First Name", text: $firstname)
                                .padding()
                                .overlay{
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.lightblue, lineWidth:1)
                                }
                                .autocapitalization(.none)

                        }
                    }
                    VStack(alignment:.leading){
                        Text("Last Name")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        HStack{
                            TextField("Enter Last Name", text: $lastname)
                                .padding()
                                .overlay{
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.lightblue, lineWidth:1)
                                }
                                .autocapitalization(.none)


                        }
                    }
                }
                .padding(.top,24)
                .padding(.horizontal,24)
                
                
                VStack(alignment:.leading){
                    HStack {
                        Text("Email ID")
                            .font(.custom("Montserrat-SemiBold", size: 14))
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
                        Text("Phone")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        Spacer()
                        if showPhone{
                            Text("Number Is \(PhoneisValid ? "Valid":"Invalid")")
                                .foregroundStyle(PhoneisValid ? .green : .red)
                                .font(.custom("Montserrat-Medium", size: 9))
                        }
                    }
                    TextField("Enter Your Phone Number", text: $phone)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.lightblue, lineWidth:1)
                        }
                        .autocapitalization(.none)

                        

                }
                .padding(.top,30)
                .padding(.horizontal,24)
                
                .onChange(of: password, { oldValue, newValue in
                    if password == ""{
                        showPassword = false
                    }else{
                        showPassword = true
                    }
                    
                    PassisValid = isValidPass(newValue)
                })
                
                .onChange(of: phone, { oldValue, newValue in
                    if phone == ""{
                        showPhone = false
                    }else{
                        showPhone = true
                    }
                    
                    PhoneisValid = isValidPhone(newValue)
                })
                
                .onChange(of: email, { oldValue, newValue in
                    if email == ""{
                        showEmail = false
                    }else{
                        showEmail = true
                    }
                    
                    EmailisValid = isValidEmail(newValue)
                })
                .onChange(of: repassword, { oldValue, newValue in
                    if repassword == ""{
                        showRePassword = false
                    }else{
                        showRePassword = true
                    }
                    
                    RePassisValid = isValidPass(newValue)
                })
                VStack(alignment:.leading){
                    HStack {
                        Text("Password")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        Spacer()
                        if showPassword{
                            Text("Email Is \(PassisValid ? "Valid":"Invalid")")
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
                
                VStack(alignment:.leading){
                    HStack {
                        Text("Confirm Password")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        Spacer()
                        
                        if showRePassword{
                            Text("RePassword is \(password == repassword ? "Same":"Invalid")")
                                .foregroundStyle(password == repassword ? .green : .red)
                                .font(.custom("Montserrat-Medium", size: 9))
                        }
                    }
                    SecureField("Cofirm Password", text: $repassword)
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
                        Image(systemName: policy ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .foregroundStyle(policy ? Color(.lightblue2) : Color.secondary)
                            .onTapGesture {
                                self.policy.toggle()
                        }
                        
                        Text("I Agree With The")
                            .font(.custom("Montserrat-Medium", size: 14))

                        Text("Privacy Policy*")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundStyle(.fcolor)
                        Spacer()
                    }
                    .padding(.horizontal,24)
                    
                    
                    VStack {
                        
                        if viewModal.showErrorMessageRegister{
                            Text("Already Your Account is Register !")
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
                                try await viewModal.createUser(withEmail:email, password:password,firstname:firstname,lastname:lastname,phone:phone)
                            }

                        }, label: {
                            Spacer()
                            Text("Create an account")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundStyle(.white)

                            Spacer()

                        })
                        .padding(.vertical,18)
                        .background(.bcolor)
                        .cornerRadius(60)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    .padding(.horizontal,24)
                    .padding(.top,26)
                    HStack{
                        Text("Already have an account? ").font(.custom("Montserrat-Medium", size: 14))
                            .padding(.bottom,10)
                        Text("Login").font(.custom("Montserrat-SemiBold", size: 14)).foregroundStyle(.fcolor)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .padding(.bottom,10)
             
                        
                    }
                   


                }
                .padding(.top,15)
                
                Spacer()
            }

        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        
        
        
    }
    func isValidPhone(_ password:String)->Bool{
        if phone.count > 9{
            return true
        }else{
            return false
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
extension SignUpView:AuthentitcationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && isValidEmail(email)
        && !password.isEmpty
        && isValidPass(password)
        && policy
        && !firstname.isEmpty
        && !lastname.isEmpty
        && !repassword.isEmpty
        && phone.count > 9
        

    }
    
    
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModal())
}
