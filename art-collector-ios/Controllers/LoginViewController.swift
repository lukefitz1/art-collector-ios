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
//    @IBOutlet var loginView: UIView!
    
//    let btnLogin:UIButton = {
//        let btn = UIButton(type:.system)
//        btn.backgroundColor = .blue
//        btn.setTitle("Logins", for: .normal)
//        btn.tintColor = .white
//        btn.layer.cornerRadius = 5
//        btn.clipsToBounds = true
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loginView.addSubview(btnLogin)
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
}

