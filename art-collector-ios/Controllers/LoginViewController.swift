//
//  ViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/12/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit
import Reachability
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordToggleSwtch: UISwitch!
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var online: Bool = false
    
    let failedLoginMessage = "Your username or password are incorrect"
    let failedLoginTitle = "Authentication error"
    let reachability = try! Reachability()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        passwordToggleSwtch.isOn = false
        passwordToggleSwtch.onTintColor = UIColor(red: 2/255, green: 99/255, blue: 150/255, alpha: 1.0)
        
        usernameInputField.delegate = self
        passwordInputField.delegate = self
        
        usernameInputField.text = ""
        passwordInputField.text = ""
        
        checkOnline()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
    
    private func checkOnline() {
        reachability.whenReachable = { _ in
            print("You are online!")
            self.online = true
        }
        reachability.whenUnreachable = { _ in
            print("You are not online")
            self.online = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let login = LoginService()
        
        if online {
            if let username = usernameInputField.text, let password = passwordInputField.text {
                
                progressHUD.show(onView: view, animated: true)
                login.login(username: username, password: password) { [weak self] success, error in
                    if let e = error {
                        print("Error logging in - \(e)")
                        self?.progressHUD.hide(onView: self!.view, animated: true)
                        
                        let alert = UIAlertController(title: self?.failedLoginTitle, message: self?.failedLoginMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: {
                            action in
                            self?.clearInputFields()
                        })
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                        
                        return
                    } else {
                        KeychainWrapper.standard.set(username, forKey: "username")
                        KeychainWrapper.standard.set(password, forKey: "password")
                        KeychainWrapper.standard.set(username, forKey: "accessToken")
                        KeychainWrapper.standard.set(password, forKey: "tokenType")
                        KeychainWrapper.standard.set(username, forKey: "client")
                        KeychainWrapper.standard.set(password, forKey: "expiry")
                        KeychainWrapper.standard.set(username, forKey: "uid")
                        
                        self?.progressHUD.hide(onView: self!.view, animated: true)
                        self!.performSegue(withIdentifier: "TabBarSegue", sender: nil)
                    }
                }
            }
        } else {
            if let username = usernameInputField.text, let password = passwordInputField.text {
                progressHUD.show(onView: view, animated: true)
                
                let retrievedUsername: String? = KeychainWrapper.standard.string(forKey: "username")
                let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "password")
                let retrievedAccessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
                let retrievedTokenType: String? = KeychainWrapper.standard.string(forKey: "tokenType")
                let retrievedClient: String? = KeychainWrapper.standard.string(forKey: "client")
                let retrievedExpiry: String? = KeychainWrapper.standard.string(forKey: "expiry")
                let retrievedUid: String? = KeychainWrapper.standard.string(forKey: "uid")
                
                if retrievedUsername == username && retrievedPassword == password {
                    progressHUD.hide(onView: view, animated: true)
                    performSegue(withIdentifier: "TabBarSegue", sender: nil)
                                        
                    if let accessToken = retrievedAccessToken {
                        ApiClient.accessToken = accessToken
                    }
                    
                    if let tokenType = retrievedTokenType {
                        ApiClient.tokenType = tokenType
                    }
                    
                    if let client = retrievedClient {
                        ApiClient.client = client
                    }
                    
                    if let expiry = retrievedExpiry {
                        ApiClient.expiry = expiry
                    }
                    
                    if let uid = retrievedUid {
                        ApiClient.uid = uid
                    }
                }
            }
        }
    }
    
    @IBAction func passwordTogglePressed(_ sender: Any) {
        if passwordToggleSwtch.isOn {
            passwordInputField.isSecureTextEntry = false
        } else {
            passwordInputField.isSecureTextEntry = true
        }
    }
    
    private func clearInputFields() {
        usernameInputField.text = ""
        passwordInputField.text = ""
    }
}

extension LoginViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}


