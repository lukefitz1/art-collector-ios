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
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        additionalInfoTextField.delegate = self
        biographyTextField.delegate = self
        
        biographyTextField.layer.borderWidth = 0.5
        biographyTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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

extension ArtistCreateViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
