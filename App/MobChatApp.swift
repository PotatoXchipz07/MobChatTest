//
//  MobChatApp.swift
//  MobChat
//
//  Created by Mac on 24/01/25.
//

import SwiftUI
import Firebase
import SwiftData
@main
struct MobChatApp: App {
    @StateObject var viewModal = AuthViewModal()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModal)
        }
        .modelContainer(for:UserSession.self)
    }
}
