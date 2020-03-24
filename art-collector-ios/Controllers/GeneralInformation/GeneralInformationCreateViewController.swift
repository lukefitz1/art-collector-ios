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
        
        createGeneralInformationCoreData(infoLabel: informationLabel, info: information, createdAt: createDate)
    }
    
    private func createGeneralInformationCoreData(infoLabel: String, info: String, createdAt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "GeneralInformationCore", in: context)!
        let newGI = NSManagedObject(entity: entity, insertInto: context)
        
        progressHUD.show(onView: view, animated: true)
        newGI.setValue(UUID(), forKey: "id")
        newGI.setValue(createdAt, forKey: "createdAt")
        newGI.setValue(createdAt, forKey: "updatedAt")
        newGI.setValue(info, forKey: "information")
        newGI.setValue(infoLabel, forKey: "informationLabel")
        
        saveNewItem()
        progressHUD.hide(onView: self.view, animated: true)
        performSegue(withIdentifier: "unwindToGeneralInformationSegue", sender: self)
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new GI to database = \(error)")
        }
    }
}
