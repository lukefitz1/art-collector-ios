//
//  ArtistCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    @IBOutlet weak var biographyTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        additionalInfoTextField.delegate = self
        biographyTextField.delegate = self
        
        biographyTextField.layer.borderWidth = 0.5
        biographyTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func newArtistBtnPressed(_ sender: Any) {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let additionalInfo = additionalInfoTextField.text ?? ""
        let biography = biographyTextField.text ?? ""
        
        createArtist(fName: firstName, lName: lastName, addInfo: additionalInfo, bio: biography)
        self.performSegue(withIdentifier: "unwindToArtistsSegue", sender: self)
    }
    
    private func createArtist(fName: String, lName: String, addInfo: String, bio: String) {
        let artistCreateService = ArtistCreateService()
        
        artistCreateService.createArtist(fName: fName, lName: lName, bio: bio, additionalInfo: addInfo, image: "") { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue posting artist data (Artists POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Artists POST request")
                
                if let artist = artistData {
//                    self.artists = artists
                    print(artist)
                }
            }
        }
    }
}
