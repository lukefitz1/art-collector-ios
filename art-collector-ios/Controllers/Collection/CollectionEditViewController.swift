//
//  CollectionEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CollectionEditViewController: UIViewController {
    
    var collection: Collection?
    
    @IBOutlet weak var collectionName: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var collectionIdentifier: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionName.text = collection?.collectionName
        year.text = collection?.year
        collectionIdentifier.text = collection?.identifier
    }
}
