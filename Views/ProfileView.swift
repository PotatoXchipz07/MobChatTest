//
//  ProfileView.swift
//  MobChat
//
//  Created by Mac on 28/01/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @EnvironmentObject var viewModal:AuthViewModal

    @Environment (\.presentationMode) var presentationMode
    @State var firstname = ""
    @State var lastname = ""
    @State var email = ""
    @State var phone = ""
    @State var images = ""
    @State private var image = UIImage(resource: .uploadprofile)

    @State private var showSheet = false
    @State var showALert = false
    var body: some View {
        NavigationView{
            VStack{
                
                
                ZStack{
                    Button(action: {
                        showSheet = true
                    }, label: {
                        AsyncImage(url: URL(string: images))
                            .frame(width: 104,height: 104)
                            .cornerRadius(10)
                        
                            .overlay(alignment:.centerLastTextBaseline){
                                Button(action: {
                                    uploadPhoto()
                                }, label: {
                                    Image(.uploadimg)
                                        .padding(.bottom,-20)
                                })
                            }
                    })
                    

                   
                }
                
                VStack(spacing:15){
                    TextField("Enter Your First Name", text: $firstname)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth:3)
                        }
                        .autocapitalization(.none)
                    
                    TextField("Enter Your LastName", text: $lastname)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth:3)
                        }
                        .autocapitalization(.none)
                    
                    TextField("Enter Your Email ID", text: $email)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth:3)
                        }
                        .autocapitalization(.none)
                    TextField("Enter Your Phone", text: $phone)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth:3)
                        }
                        .autocapitalization(.none)
                    
                    
                    VStack {
                        Button(action: {
                            uploadPhoto()
                            showALert = true
                        }, label: {
                            Spacer()
                            Text("Save")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                        })
                        .padding(.vertical,18)
                        .background(.bcolor)
                        .alert("Your Information is Updated!", isPresented: $showALert) {
                            Button("OK", role: .cancel) { }
                        }
                    .cornerRadius(60)

                        Button(action: {
                            viewModal.showErrorMessage = false
                            viewModal.signOut()
                     
                        }, label: {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                .foregroundStyle(.white)
                            Text("Logout")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                        })
                        .padding(.vertical,18)
                        .background(.bcolor)
                        .cornerRadius(60)
                    }
                    .padding()


                }
                .padding(.top,30)



                
                
                Spacer()
                
            }
           

            
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(.backbtnblue)
                            .resizable()
                            .frame(width: 40,height: 40)
                    })
        
                  
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit Profile")
                    .font(.custom("Montserrat-Medium", size: 24))
                    .foregroundStyle(.blue)
                    .bold()
                }
            }

            .ignoresSafeArea()
            .padding()

            
        }
        .onAppear{
            viewModal.fetchUserDetail{
                firstname = viewModal.object?.fistname ?? ""
                lastname = viewModal.object?.lastname ?? ""
                email = viewModal.object?.email ?? ""
                phone = viewModal.object?.phone ?? ""
                images = viewModal.object?.profile_image ?? ""
            }
        }
        .sheet(isPresented: $showSheet, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        })
        .navigationBarBackButtonHidden()
        
        

        
        
 
        
    }
    
    func uploadPhoto(){
        let randomInt = Int.random(in: 0..<100)
        let imagelink = "https://randomuser.me/api/portraits/men/\(randomInt).jpg"
        viewModal.updateProfileDetial(firstname: firstname, lastname: lastname, email: email, phone: phone, profile_image: imagelink)
        
        
    }
    
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModal())
}
