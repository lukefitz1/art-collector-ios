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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let login = LoginService()
        
        if let username = usernameInputField.text, let password = passwordInputField.text {
            login.login(username: username, password: password) { [weak self] success, error in
                if let e = error {
                    print(e)
                }
                
                if error != nil {
                    return
                } else {
                    self!.performSegue(withIdentifier: "TabBarSegue", sender: nil)
                }
            }
        }
    }
}

