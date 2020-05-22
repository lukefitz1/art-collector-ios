//
//  ArtistEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtistEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var artist: Artist?
    var artistCore: ArtistCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    @IBOutlet weak var biographyTextField: UITextView!
    
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
        
        firstNameTextField.text = artistCore?.firstName
        lastNameTextField.text = artistCore?.lastName
        additionalInfoTextField.text = artistCore?.additionalInfo
        biographyTextField.text = artistCore?.biography
        
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
    
    @IBAction func updateArtistBtnPressed(_ sender: Any) {
        guard let artistCoreId = artistCore?.id else { return }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let additionalInfo = additionalInfoTextField.text ?? ""
        let biography = biographyTextField.text ?? ""
        let updateDate = DateUtility.getFormattedDateAsString()
        
        updateArtistCoreData(id: artistCoreId, firstName: firstName, lastName: lastName, additionalInfo: additionalInfo, biography: biography, updatedAt: updateDate)
    }
    
    private func updateArtistCoreData(id: UUID, firstName: String, lastName: String, additionalInfo: String, biography: String, updatedAt: String) {
        let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        progressHUD.show(onView: view, animated: true)
        do {
            let artist = try context.fetch(request)
            
            let updateArtist = artist[0] as NSManagedObject
            updateArtist.setValue(updatedAt, forKey: "updatedAt")
            updateArtist.setValue(firstName, forKey: "firstName")
            updateArtist.setValue(lastName, forKey: "lastName")
            updateArtist.setValue(additionalInfo, forKey: "additionalInfo")
            updateArtist.setValue(biography, forKey: "biography")
            
        } catch {
            print("Error updating artist information = \(error)")
        }
        
        saveUpdatedItem()
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.progressHUD.hide(onView: self.view, animated: true)
            self.performSegue(withIdentifier: "unwindToArtistDetailSegue", sender: self)
        } catch {
            self.progressHUD.hide(onView: self.view, animated: true)
            print("Error saving the updated Artist to database = \(error)")
        }
    }
}

extension ArtistEditViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
