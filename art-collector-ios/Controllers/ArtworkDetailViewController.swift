//
//  ArtworkDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtworkDetailViewController: UIViewController {
    
    @IBOutlet weak var objectId: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    @IBOutlet weak var artType: UILabel!
    
    var artwork: Artwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objectId.text = artwork?.objectId
        artTitle.text = artwork?.title
        artType.text = artwork?.artType
    }
    
}
