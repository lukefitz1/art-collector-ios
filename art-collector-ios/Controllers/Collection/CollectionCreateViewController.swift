//
//  CollectionCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CollectionCreateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionNameTextField: UITextField!
    @IBOutlet weak var collectionYearTextField: UITextField!
    @IBOutlet weak var collectionIdentifierTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var customerId: String = ""
    var customerCoreId: UUID = UUID()
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        collectionNameTextField.delegate = self
        collectionYearTextField.delegate = self
        collectionIdentifierTextField.delegate = self
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
    
    @IBAction func newCollectiontBtnPressed(_ sender: Any) {
        let collName = collectionNameTextField.text ?? ""
        let collYear = collectionYearTextField.text ?? ""
        let collIdentifier = collectionIdentifierTextField.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
        createCollectionCoreData(name: collName, year: collYear, identifier: collIdentifier, createdAt: createDate)
    }
    
    private func createCollectionCoreData(name: String, year: String, identifier: String, createdAt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "CollectionCore", in: context)!
        let newCollection = NSManagedObject(entity: entity, insertInto: context)
        
        progressHUD.show(onView: view, animated: true)
        newCollection.setValue(UUID(), forKey: "id")
        newCollection.setValue(createdAt, forKey: "createdAt")
        newCollection.setValue(createdAt, forKey: "updatedAt")
        newCollection.setValue(name, forKey: "collectionName")
        newCollection.setValue(year, forKey: "year")
        newCollection.setValue(identifier, forKey: "identifier")
        newCollection.setValue(customerCoreId, forKey: "customerId")
        
        saveNewItem()
        progressHUD.hide(onView: self.view, animated: true)
        performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new collection to database = \(error)")
        }
    }
}

extension CollectionCreateViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
