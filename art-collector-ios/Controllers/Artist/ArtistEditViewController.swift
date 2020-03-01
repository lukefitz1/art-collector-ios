//
//  ArtistEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistEditViewController: UIViewController {
    
    var artist: Artist?
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var additionalInfo: UITextField!
    @IBOutlet weak var biography: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = artist?.firstName
        lastName.text = artist?.lastName
        additionalInfo.text = artist?.additionalInfo
        biography.text = artist?.biography
    }
    
    @IBAction func updateArtistBtnPressed(_ sender: Any) {
    
    }
}
