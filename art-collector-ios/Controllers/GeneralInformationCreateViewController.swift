//
//  GeneralInformationCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/19/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class GeneralInformationCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var informationLabelTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationLabelTextField.delegate = self
        informationTextView.delegate = self
        
        informationTextView.layer.borderWidth = 0.5
        informationTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func newGeneralInfoBtnPressed(_ sender: Any) {
        let informationLabel = informationLabelTextField.text ?? ""
        let information = informationTextView.text ?? ""
        
        createGeneralInformation(infoLabel: informationLabel, info: information)
         self.performSegue(withIdentifier: "unwindToGeneralInformationSegue", sender: self)
    }
    
    private func createGeneralInformation(infoLabel: String, info: String) {
        let giCreateService = GeneralInformationCreateService()
        
        giCreateService.createGeneralInformation(infoLabel: infoLabel, info: infoLabel) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue creating GI data (GI POST request) - \(e)")
                return
            } else {
                print("SUCCESS - GI POST request")
                
                if let generalInfo = giData {
                    print(generalInfo)
                }
            }
        }
    }
}
