//
//  AnalyticView.swift
//  MobChat
//
//  Created by Mac on 17/02/25.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseRemoteConfig

final class AnalyticManager{
    static let shared = AnalyticManager()
    
    private init() {}
    
    func logEvent(name:String,params:[String:Any]? = nil){
        Analytics.logEvent(name, parameters: params)
    }
    func setUserId(userId:String){
        Analytics.setUserID(userId)
    }
    func setUserProperty(value:String?,property:String){
        Analytics.setUserProperty(value, forName: property)
    }
}
struct AnalyticView: View {
    @EnvironmentObject var viewModal:AuthViewModal
//    @RemoteConfigProperty(key: "term", fallback: "No Condition") private var text:String
    @StateObject var rvm = RemoteViewModel()
    var body: some View {
        
        VStack{
            Text(rvm.text)
                .foregroundStyle(.red)
                .font(.system(size: 24))
//                .onAppear{
////                    RemoteConfig.remoteConfig().fetchAndActivate()
//                }
            Button(action: {
                AnalyticManager.shared.logEvent(name: "Anylytic_View")
            }, label: {
                Text("Click Me !")
            })
            Button(action: {
                AnalyticManager.shared.logEvent(name: "Anylytic_View",params: [
                    "User":"Anil"
                ])
                

            }, label: {
                Text("Click Me Too!")
            })

        }
        .onAppear{
            AnalyticManager.shared.logEvent(name: "Anylytic_View User Appear")
            

        }
        .onDisappear{
            AnalyticManager.shared.logEvent(name: "Anylytic_View User Appear")
            AnalyticManager.shared.setUserId(userId: viewModal.currentUserUID)
            AnalyticManager.shared.setUserProperty(value: true.description, property: "Premium User")
        }
    }
}

#Preview {
    AnalyticView()
}
