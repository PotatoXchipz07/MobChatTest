//
//  CrashView.swift
//  MobChat
//
//  Created by Mac on 17/02/25.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

final class CrashManager{
    static let shared = CrashManager()
    
    private init(){}
    
    func setUserId(userID:String){
        Crashlytics.crashlytics().setUserID(userID)
    }
    private func setValue(value:String,key:String){
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    func setPremiumValue(isPremiumUser:Bool){
        setValue(value: isPremiumUser.description.lowercased(), key: "User is Premium")
    }
    func addLog(message:String){
        Crashlytics.crashlytics().log(message)
    }
    func sendNonFatal(error:Error){
        Crashlytics.crashlytics().record(error: error)
    }
    
}
struct CrashView: View {
    @EnvironmentObject var viewModal:AuthViewModal

    var body: some View {
        VStack(spacing:50){
            Button(action: {
                CrashManager.shared.addLog(message: "User Click on Crash 1")

                let string1:String? = nil
                guard let string1 else{
                    CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                    return
                }
                _ = string1
            }, label: {
                Text("Crash 1")
            })
            Button(action: {
                CrashManager.shared.addLog(message: "User Click on Crash 2")
                fatalError("FatalError Crash 2")
            }, label: {
                Text("Crash 2")
            })
            Button(action: {
                CrashManager.shared.addLog(message: "User Click on Crash 1")
                let arr:[String] = []
                let item = arr[0]
            }, label: {
                Text("Crash 3")
                
            })
            
        }
        .onAppear{
            CrashManager.shared.setPremiumValue(isPremiumUser: true)
            CrashManager.shared.addLog(message: "CrashView Appear")
            CrashManager.shared.setUserId(userID: viewModal.currentUserUID)
        }
        

    }
}

#Preview {
    CrashView()
        .environmentObject(AuthViewModal())
}
