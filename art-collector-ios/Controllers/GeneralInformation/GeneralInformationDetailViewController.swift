//
//  GeneralInformationDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class GeneralInformationDetailViewController: UIViewController {
    
    @IBOutlet weak var giLabel: UILabel!
    @IBOutlet weak var giText: UILabel!
    
    var generalInfo: GeneralInformation?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        giLabel.text = generalInfo?.infoLabel
        giText.text = generalInfo?.information
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditGeneralInformationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "EditGeneralInformationSegue" {
           let destinationVC = segue.destination as! GeneralInformationEditViewController

           destinationVC.generalInfo = generalInfo
       }
   }
}
