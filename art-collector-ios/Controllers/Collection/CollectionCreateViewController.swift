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
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionNameTextField.delegate = self
        collectionYearTextField.delegate = self
        collectionIdentifierTextField.delegate = self
    }
    
    @IBAction func newCollectiontBtnPressed(_ sender: Any) {
        let collName = collectionNameTextField.text ?? ""
        let collYear = collectionYearTextField.text ?? ""
        let collIdentifier = collectionIdentifierTextField.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
        let entity = NSEntityDescription.entity(forEntityName: "CollectionCore", in: context)!
        let newGI = NSManagedObject(entity: entity, insertInto: context)
        newGI.setValue(UUID(), forKey: "id")
        newGI.setValue(createDate, forKey: "createdAt")
        newGI.setValue(createDate, forKey: "updatedAt")
        
//        saveNewItem()
        createCollection(name: collName, year: collYear, identifier: collIdentifier)
    }
    
    private func createCollection(name: String, year: String, identifier: String) {
        let collectionCreateService = CollectionCreateService()
        
        progressHUD.show(onView: view, animated: true)
        collectionCreateService.createCollection(name: name, year: year, identifier: identifier, customerId: customerId) { [weak self] collectionData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue posting artist data (Collection POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Collection POST request")
                
                if let collection = collectionData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
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
