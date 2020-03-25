//
//  ArtistCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtistCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    @IBOutlet weak var biographyTextField: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        additionalInfoTextField.delegate = self
        biographyTextField.delegate = self
        
        biographyTextField.layer.borderWidth = 0.5
        biographyTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func newArtistBtnPressed(_ sender: Any) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let additionalInfo = additionalInfoTextField.text ?? ""
        let biography = biographyTextField.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
        createArtistCoreData(fName: firstName, lName: lastName, addInfo: additionalInfo, bio: biography, createdAt: createDate)
    }
    
    private func createArtistCoreData(fName: String, lName: String, addInfo: String, bio: String, createdAt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "ArtistCore", in: context)!
        let newArtist = NSManagedObject(entity: entity, insertInto: context)
        
        progressHUD.show(onView: view, animated: true)
        newArtist.setValue(UUID(), forKey: "id")
        newArtist.setValue(createdAt, forKey: "createdAt")
        newArtist.setValue(createdAt, forKey: "updatedAt")
        newArtist.setValue(fName, forKey: "firstName")
        newArtist.setValue(lName, forKey: "lastName")
        newArtist.setValue(bio, forKey: "biography")
        newArtist.setValue(addInfo, forKey: "additionalInfo")
        newArtist.setValue("", forKey: "artistImage")
        
        saveNewItem()
        self.progressHUD.hide(onView: self.view, animated: true)
        self.performSegue(withIdentifier: "unwindToArtistsSegue", sender: self)
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new artist to database = \(error)")
        }
    }
}
