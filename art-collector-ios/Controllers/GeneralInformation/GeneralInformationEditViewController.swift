//
//  GeneralInformationEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class GeneralInformationEditViewController: UIViewController {
    
    var generalInfo: GeneralInformation?
    var generalInfoCore: GeneralInformationCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var informationLabelTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationLabelTextField.text = generalInfoCore?.informationLabel
        informationTextView.text = generalInfoCore?.information
        
        informationTextView.layer.borderWidth = 0.5
        informationTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func updateGIBtnPressed(_ sender: Any) {
        let informationLabel = informationLabelTextField.text ?? ""
        let information = informationTextView.text ?? ""
        guard let generalInfoCoreId = generalInfoCore?.id else { return }
        let updateDate = DateUtility.getFormattedDateAsString()
        
        updateArtistCoreData(id: generalInfoCoreId, infoLabel: informationLabel, info: information, updatedAt: updateDate)
    }
    
    private func updateArtistCoreData(id: UUID, infoLabel: String, info: String, updatedAt: String) {
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        progressHUD.show(onView: view, animated: true)
        do {
            let gi = try context.fetch(request)
            
            let updateGI = gi[0] as NSManagedObject
            updateGI.setValue(updatedAt, forKey: "updatedAt")
            updateGI.setValue(info, forKey: "information")
            updateGI.setValue(infoLabel, forKey: "informationLabel")
            
        } catch {
            print("Error updating general information = \(error)")
        }
        
        saveUpdatedItem()
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.progressHUD.hide(onView: self.view, animated: true)
            self.performSegue(withIdentifier: "unwindToGeneralInformationDetailSegue", sender: self)
        } catch {
            print("Error saving the updated GI to database = \(error)")
        }
    }
}
