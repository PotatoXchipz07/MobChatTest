//
//  ContentView.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI


struct ContentView: View {

    @EnvironmentObject var viewModal:AuthViewModal
    @Environment (\.modelContext) var modelContext


    var body: some View {
        Group{
            if viewModal.userSession != nil {
//                viewModal.userUID = viewModal.userSession?.uid
                ChatView()
            }else{
                LoginView()
//                    .modelContainer(for: UserSession.self)
            }
        }

     
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModal())


}
