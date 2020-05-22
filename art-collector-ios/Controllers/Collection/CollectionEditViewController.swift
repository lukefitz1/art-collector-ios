//
//  CollectionEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CollectionEditViewController: UIViewController, UITextFieldDelegate {
    
    var customer: Customer?
    var customerCore: CustomerCore?
    var collection: Collection?
    var collectionCore: CollectionCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    @IBOutlet weak var collectionNameTextField: UITextField!
    @IBOutlet weak var collectionYearTextField: UITextField!
    @IBOutlet weak var collectionIdentifierTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        collectionNameTextField.delegate = self
        collectionYearTextField.delegate = self
        collectionIdentifierTextField.delegate = self
        
        collectionNameTextField.text = collectionCore?.collectionName
        collectionYearTextField.text = collectionCore?.year
        collectionIdentifierTextField.text = collectionCore?.identifier
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func updateCollectionBtnPressed(_ sender: Any) {
        guard let collectionId = collectionCore?.id else { return }
        guard let customerCoreId = customerCore?.id else { return }
        
        let collectionName = collectionNameTextField.text ?? ""
        let collectionYear = collectionYearTextField.text ?? ""
        let collectionIdentifier = collectionIdentifierTextField.text ?? ""
        let updateDate = DateUtility.getFormattedDateAsString()

        updateCollectionCore(id: collectionId, name: collectionName, year: collectionYear, identifier: collectionIdentifier, updatedAt: updateDate, customerId: customerCoreId)
    }
    
    private func updateCollectionCore(id: UUID, name: String, year: String, identifier: String, updatedAt: String, customerId: UUID) {
        let request: NSFetchRequest<CollectionCore> = CollectionCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        
        defer {
            progressHUD.hide(onView: self.view, animated: true)
        }
        
        progressHUD.show(onView: view, animated: true)
        do {
            let collection = try context.fetch(request)
            
            let updateCollection = collection[0] as NSManagedObject
            updateCollection.setValue(updatedAt, forKey: "updatedAt")
            updateCollection.setValue(name, forKey: "collectionName")
            updateCollection.setValue(year, forKey: "year")
            updateCollection.setValue(identifier, forKey: "identifier")
            updateCollection.setValue(customerId, forKey: "customerId")
            
        } catch {
            print("Error updating collection information = \(error)")
        }
        
        saveUpdatedItem()
        progressHUD.hide(onView: self.view, animated: true)
//        performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.performSegue(withIdentifier: "unwindToCollectionDetailSegue", sender: self)
        } catch {
            print("Error saving the updated collection to database = \(error)")
        }
    }
}

extension CollectionEditViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
