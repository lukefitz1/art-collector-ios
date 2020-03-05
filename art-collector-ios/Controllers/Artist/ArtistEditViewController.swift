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
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    @IBOutlet weak var biographyTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = artist?.firstName
        lastNameTextField.text = artist?.lastName
        additionalInfoTextField.text = artist?.additionalInfo
        biographyTextField.text = artist?.biography
    }
    
    @IBAction func updateArtistBtnPressed(_ sender: Any) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let additionalInfo = additionalInfoTextField.text ?? ""
        let biography = biographyTextField.text ?? ""
        let artistId = artist?.id ?? ""
        
        updateArtist(artistId: artistId, fName: firstName, lName: lastName, addInfo: additionalInfo, bio: biography)
    }
    
    private func updateArtist(artistId: String, fName: String, lName: String, addInfo: String, bio: String) {
        let artistEditService = ArtistEditService()
        
        progressHUD.show(onView: view, animated: true)
        artistEditService.updateArtist(id: artistId, fName: fName, lName: lName, bio: bio, additionalInfo: addInfo, image: "") { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue creating artist data (GI PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - artist PUT request")
                
                if let artist = artistData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToArtistDetailSegue", sender: self)
                }
            }
        }
    }
}
