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
        
        if retrievedUsername == nil && retrievedPassword == nil {
            return false
        }
        
        return true
    }
}
