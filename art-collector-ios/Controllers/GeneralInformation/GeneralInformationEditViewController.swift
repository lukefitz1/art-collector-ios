//
//  GeneralInformationEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class GeneralInformationEditViewController: UIViewController {
    
    var generalInfo: GeneralInformation?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    @IBOutlet weak var informationLabelTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationLabelTextField.text = generalInfo?.infoLabel
        informationTextView.text = generalInfo?.information
        
        informationTextView.layer.borderWidth = 0.5
        informationTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func updateGIBtnPressed(_ sender: Any) {
        let informationLabel = informationLabelTextField.text ?? ""
        let information = informationTextView.text ?? ""
        let generalInfoId = generalInfo?.id ?? ""
        
        updateGeneralInformation(giId: generalInfoId, infoLabel: informationLabel, info: information)
    }
    
    private func updateGeneralInformation(giId: String, infoLabel: String, info: String) {
        let giEditService = GeneralInformationEditService()
        
        progressHUD.show(onView: view, animated: true)
        giEditService.updateGeneralInformation(id: giId, infoLabel: infoLabel, info: info) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue creating GI data (GI PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - GI PUT request")
                
                if let generalInfo = giData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToGeneralInformationDetailSegue", sender: self)
                }
            }
        }
    }
}
