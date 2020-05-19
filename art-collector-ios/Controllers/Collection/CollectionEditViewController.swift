//
//  CollectionEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CollectionEditViewController: UIViewController {
    
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
        
        collectionNameTextField.text = collectionCore?.collectionName
        collectionYearTextField.text = collectionCore?.year
        collectionIdentifierTextField.text = collectionCore?.identifier
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
    
//    private func updateCollection(collId: String, name: String, year: String, collIdentifier: String, customerId: String) {
//        let collectionEditService = CollectionEditService()
//        
//        progressHUD.show(onView: view, animated: true)
//        collectionEditService.updateCollection(id: collId,
//                                               name: name,
//                                               year: year,
//                                               identifier: collIdentifier,
//                                               customerId: customerId) { [weak self] collectionData, error in
//                                                guard let self = self else {
//                                                    return
//                                                }
//                                                
//                                                if let e = error {
//                                                    print("Issue updating collection data (Collection PUT request) - \(e)")
//                                                    return
//                                                } else {
//                                                    print("SUCCESS - collection PUT request")
//                                                    
//                                                    if let collection = collectionData {
//                                                        self.progressHUD.hide(onView: self.view, animated: true)
//                                                        self.performSegue(withIdentifier: "unwindToCollectionDetailSegue", sender: self)
//                                                    }
//                                                }
//        }
//    }
}
