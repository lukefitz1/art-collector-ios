//
//  GeneralInformationDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class GeneralInformationDetailViewController: UIViewController {
    
    @IBOutlet weak var giLabel: UILabel!
    @IBOutlet weak var giText: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var generalInfo: GeneralInformation?
    var generalInfoCore: GeneralInformationCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        giLabel.text = generalInfoCore?.informationLabel
        giText.text = generalInfoCore?.information
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditGeneralInformationSegue", sender: self)
    }
    
    @IBAction func unwindToGeneralInformationDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let gi = self.generalInfoCore?.id {
                    self.getGeneralInfoCore(id: gi)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "EditGeneralInformationSegue" {
            let destinationVC = segue.destination as! GeneralInformationEditViewController

            destinationVC.generalInfoCore = generalInfoCore
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
    
    private func getGeneralInfoCore(id: UUID) {
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)

        progressHUD.show(onView: view, animated: true)
        do {
            let gi = try context.fetch(request)
//            let updatedGI = gi[0] as NSManagedObject
            let updatedGI2 = gi[0] as GeneralInformationCore
            refreshGeneralInfoCore(gi: updatedGI2)
        } catch {
            print("Error getting updated general information = \(error)")
        }
        self.progressHUD.hide(onView: self.view, animated: true)
    }
    
    private func refreshGeneralInfoCore(gi: GeneralInformationCore) {
        giLabel.text = gi.informationLabel
        giText.text = gi.information
    }
    
    private func refreshGeneralInfo(gi: GeneralInformation) {
        giLabel.text = gi.infoLabel
        giText.text = gi.information
    }
}
