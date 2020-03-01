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
    
    @IBOutlet weak var giLabel: UITextField!
    @IBOutlet weak var giInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giLabel.text = generalInfo?.infoLabel
        giInfo.text = generalInfo?.information
    }
    
    @IBAction func updateGIBtnPressed(_ sender: Any) {
        
    }
}
