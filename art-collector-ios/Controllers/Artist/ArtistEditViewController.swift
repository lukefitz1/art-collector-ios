//
//  ArtistEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtistEditViewController: UIViewController {
    
    var artist: Artist?
    var artistCore: ArtistCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    @IBOutlet weak var biographyTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = artistCore?.firstName
        lastNameTextField.text = artistCore?.lastName
        additionalInfoTextField.text = artistCore?.additionalInfo
        biographyTextField.text = artistCore?.biography
    }
    
    @IBAction func updateArtistBtnPressed(_ sender: Any) {
        guard let artistCoreId = artistCore?.id else { return }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let additionalInfo = additionalInfoTextField.text ?? ""
        let biography = biographyTextField.text ?? ""
        let updateDate = DateUtility.getFormattedDateAsString()
        
        updateArtistCoreData(id: artistCoreId, firstName: firstName, lastName: lastName, additionalInfo: additionalInfo, biography: biography, updatedAt: updateDate)
    }
    
    private func updateArtistCoreData(id: UUID, firstName: String, lastName: String, additionalInfo: String, biography: String, updatedAt: String) {
        let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        progressHUD.show(onView: view, animated: true)
        do {
            let artist = try context.fetch(request)
            
            let updateArtist = artist[0] as NSManagedObject
            updateArtist.setValue(updatedAt, forKey: "updatedAt")
            updateArtist.setValue(firstName, forKey: "firstName")
            updateArtist.setValue(lastName, forKey: "lastName")
            updateArtist.setValue(additionalInfo, forKey: "additionalInfo")
            updateArtist.setValue(biography, forKey: "biography")
            
        } catch {
            print("Error updating artist information = \(error)")
        }
        
        saveUpdatedItem()
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.progressHUD.hide(onView: self.view, animated: true)
            self.performSegue(withIdentifier: "unwindToArtistDetailSegue", sender: self)
        } catch {
            self.progressHUD.hide(onView: self.view, animated: true)
            print("Error saving the updated Artist to database = \(error)")
        }
    }
    
//    private func updateArtist(artistId: String, fName: String, lName: String, addInfo: String, bio: String) {
//        let artistEditService = ArtistEditService()
//
//        progressHUD.show(onView: view, animated: true)
//        artistEditService.updateArtist(id: artistId, fName: fName, lName: lName, bio: bio, additionalInfo: addInfo, image: "") { [weak self] artistData, error in
//            guard let self = self else {
//                return
//            }
//
//            if let e = error {
//                print("Issue creating artist data (GI PUT request) - \(e)")
//                return
//            } else {
//                print("SUCCESS - artist PUT request")
//
//                if let artist = artistData {
//                    self.progressHUD.hide(onView: self.view, animated: true)
//                    self.performSegue(withIdentifier: "unwindToArtistDetailSegue", sender: self)
//                }
//            }
//        }
//    }
}
