//
//  CollectionEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CollectionEditViewController: UIViewController {
    
    var customer: Customer?
    var collection: Collection?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    @IBOutlet weak var collectionNameTextField: UITextField!
    @IBOutlet weak var collectionYearTextField: UITextField!
    @IBOutlet weak var collectionIdentifierTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionNameTextField.text = collection?.collectionName
        collectionYearTextField.text = collection?.year
        collectionIdentifierTextField.text = collection?.identifier
    }
    
    @IBAction func updateCollectionBtnPressed(_ sender: Any) {
        let collectionName = collectionNameTextField.text ?? ""
        let collectionYear = collectionYearTextField.text ?? ""
        let collectionIdentifier = collectionIdentifierTextField.text ?? ""
        let collectionId = collection?.id ?? ""
        let customerId = customer?.id ?? ""
     
        updateCollection(collId: collectionId,
                         name: collectionName,
                         year: collectionYear,
                         collIdentifier: collectionIdentifier,
                         customerId: customerId)
    }
    
    private func updateCollection(collId: String, name: String, year: String, collIdentifier: String, customerId: String) {
        let collectionEditService = CollectionEditService()
        
        progressHUD.show(onView: view, animated: true)
        collectionEditService.updateCollection(id: collId,
                                               name: name,
                                               year: year,
                                               identifier: collIdentifier,
                                               customerId: customerId) { [weak self] collectionData, error in
                                                guard let self = self else {
                                                    return
                                                }
                                                
                                                if let e = error {
                                                    print("Issue updating collection data (Collection PUT request) - \(e)")
                                                    return
                                                } else {
                                                    print("SUCCESS - collection PUT request")
                                                    
                                                    if let collection = collectionData {
                                                        self.progressHUD.hide(onView: self.view, animated: true)
                                                        self.performSegue(withIdentifier: "unwindToCollectionDetailSegue", sender: self)
                                                    }
                                                }
        }
    }
}
