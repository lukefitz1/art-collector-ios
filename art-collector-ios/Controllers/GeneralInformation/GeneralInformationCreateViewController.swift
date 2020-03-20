//
//  GeneralInformationCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/19/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class GeneralInformationCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var informationLabelTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        informationLabelTextField.delegate = self
        informationTextView.delegate = self
        
        informationTextView.layer.borderWidth = 0.5
        informationTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func newGeneralInfoBtnPressed(_ sender: Any) {
        let informationLabel = informationLabelTextField.text ?? ""
        let information = informationTextView.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
        print("Information label: \(informationLabel)")
        print("Information label: \(information)")
        
        let entity = NSEntityDescription.entity(forEntityName: "GeneralInformationCore", in: context)!
        let newGI = NSManagedObject(entity: entity, insertInto: context)
        
        newGI.setValue(UUID(), forKey: "id")
        newGI.setValue(createDate, forKey: "createdAt")
        newGI.setValue(createDate, forKey: "updatedAt")
        newGI.setValue(information, forKey: "information")
        newGI.setValue(informationLabel, forKey: "informationLabel")
        
//        saveNewItem()
        createGeneralInformation(infoLabel: informationLabel, info: information)
    }
    
    private func createGeneralInformation(infoLabel: String, info: String) {
        let giCreateService = GeneralInformationCreateService()
        
        progressHUD.show(onView: view, animated: true)
        giCreateService.createGeneralInformation(infoLabel: infoLabel, info: info) { [weak self] giData, error in
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
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToGeneralInformationSegue", sender: self)
                }
            }
        }
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new GI to database = \(error)")
        }
    }
}
