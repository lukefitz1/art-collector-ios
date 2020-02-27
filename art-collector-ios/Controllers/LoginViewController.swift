//
//  ViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/12/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordToggleSwtch: UISwitch!
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
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
        passwordToggleSwtch.onTintColor =  UIColor.blue
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let login = LoginService()
        
        if let username = usernameInputField.text, let password = passwordInputField.text {
            
            progressHUD.show(onView: view, animated: true)
            login.login(username: username, password: password) { [weak self] success, error in
                if let e = error {
                    print(e)
                }
                
                if error != nil {
                    return
                } else {
                    self?.progressHUD.hide(onView: self!.view, animated: true)
                    self!.performSegue(withIdentifier: "TabBarSegue", sender: nil)
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
}

extension LoginViewController {
    @objc func keyboardWillChange(notification: Notification) {
        view.frame.origin.y = -75
    }
}


