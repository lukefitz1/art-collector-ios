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
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
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
    
    @IBAction func unwindToGeneralInformationDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let gi = self.generalInfo?.id {
                    self.getGeneralInfo(giId: gi)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "EditGeneralInformationSegue" {
           let destinationVC = segue.destination as! GeneralInformationEditViewController

           destinationVC.generalInfo = generalInfo
       }
   }
    
    private func getGeneralInfo(giId: String) {
        let getGeneralInformationService = GetGeneralInformationService()
        
        progressHUD.show(onView: view, animated: true)
        getGeneralInformationService.getGeneralInfo(giId: giId ) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting general info data (General Info GET request) - \(e)")
                return
            } else {
                if let gi = giData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.refreshGeneralInfo(gi: gi)
                }
            }
        }
    }
    
    private func refreshGeneralInfo(gi: GeneralInformation) {
        giLabel.text = gi.infoLabel
        giText.text = gi.information
    }
}
