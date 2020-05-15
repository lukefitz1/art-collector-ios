//
//  LoginManager.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 4/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

@objc
class LoginManager: NSObject {
    
    @objc var isLoggedIn: Bool {
        let retrievedUsername: String? = KeychainWrapper.standard.string(forKey: "username")
        let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "password")
        let retrievedAccessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let retrievedClient: String? = KeychainWrapper.standard.string(forKey: "client")
        let retrievedExpiry: String? = KeychainWrapper.standard.string(forKey: "expiry")

        if retrievedUsername == nil || retrievedPassword == nil || retrievedAccessToken == nil || retrievedClient == nil {
            return false
        }
        
        // TODO: Instead of checking if it is nil, check if it is expired alreaday
        if retrievedExpiry == nil {
            return false
        }
        
        return true
    }
}
