//
//  RemoteViewModel.swift
//  MobChat
//
//  Created by Mac on 18/02/25.
//

import Foundation
import FirebaseRemoteConfig
@MainActor
class RemoteViewModel:NSObject,ObservableObject{
    @Published var text:String = "Not Updated ?"
    
    
    override init() {
        super .init()
        Task{
            try await startTask()
        }

    }
    
    
    private func startTask()async throws{
        let rc = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        rc.configSettings = setting
        
        
        do{
            let config = try await rc.fetchAndActivate()
            switch config {
            case .successFetchedFromRemote:
                text = rc.configValue(forKey: "term").stringValue
                return
            case .successUsingPreFetchedData:
                text = rc.configValue(forKey: "term").stringValue
                return
            default:
                print("Failed to Fetch")
            }

            
        } catch let error{
            print("Failed to fetch Error:\(error)")
        }
    }
}
