//
//  ArtworkEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtworkEditViewController: UIViewController {
    
    var artwork: Artwork?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    @IBOutlet weak var objectIdTextField: UITextField!
    @IBOutlet weak var artTypeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mediumTextField: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dimensionsTextField: UITextField!
    @IBOutlet weak var frameDimensionsTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var dateAcquiredLabelTextField: UITextField!
    @IBOutlet weak var dateAcquiredTextField: UITextField!
    @IBOutlet weak var amountPaidTextField: UITextField!
    @IBOutlet weak var currentValueTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesImageView: UIImageView!
    @IBOutlet weak var notesImageTwoImageView: UIImageView!
    @IBOutlet weak var additionalInfoLabelTextField: UITextField!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var additionalInfoImageView: UIImageView!
    @IBOutlet weak var additionalInfoImageTwoImageView: UIImageView!
    @IBOutlet weak var reviewedByTextField: UITextField!
    @IBOutlet weak var reviewedDateTextField: UITextField!
    @IBOutlet weak var provenanceTextView: UITextView!
    @IBOutlet weak var customTitleTextField: UITextField!
    @IBOutlet weak var addNewArtworkBtn: UIButton!
    
    var decodedMainImage: String?
    var decodedNotesImage: String?
    var decodedNotesTwoImage: String?
    var decodedAdditionalInfoImage: String?
    var decodedAdditionalInfoTwoImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        additionalInfoTextView.layer.borderWidth = 0.5
        additionalInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        provenanceTextView.layer.borderWidth = 0.5
        provenanceTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        objectIdTextField.text = artwork?.objectId
        artTypeTextField.text = artwork?.artType
        titleTextField.text = artwork?.title
        dateTextField.text = artwork?.date
        dateTextField.text = artwork?.medium
        descriptionTextView.text = artwork?.description
        dimensionsTextField.text = artwork?.dimensions
        frameDimensionsTextField.text = artwork?.frameDimensions
        conditionTextField.text = artwork?.condition
        currentLocationTextField.text = artwork?.currentLocation
        sourceTextField.text = artwork?.source
        dateAcquiredLabelTextField.text = artwork?.dateAcquiredLabel
        dateAcquiredTextField.text = artwork?.dateAcquired
        amountPaidTextField.text = artwork?.amountPaid
        currentValueTextField.text = artwork?.currentValue
        notesTextView.text = artwork?.notes
        additionalInfoLabelTextField.text = artwork?.additionalInfoLabel
        additionalInfoTextView.text = artwork?.additionalInfoText
        reviewedByTextField.text = artwork?.reviewedBy
        reviewedDateTextField.text = artwork?.reviewedDate
        provenanceTextView.text = artwork?.provenance
        customTitleTextField.text = artwork?.customTitle
    }
    
    @IBAction func updateArtworkBtnPressed(_ sender: Any) {
        let objectId = objectIdTextField.text ?? ""
        let artType = artTypeTextField.text ?? ""
        let title = titleTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let medium = mediumTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let mainImage = decodedMainImage ?? ""
        let dimensions = dimensionsTextField.text ?? ""
        let frameDimensions = frameDimensionsTextField.text ?? ""
        let condition = conditionTextField.text ?? ""
        let currentLocation = currentLocationTextField.text ?? ""
        let source = sourceTextField.text ?? ""
        let dateAcquiredLabel = dateAcquiredLabelTextField.text ?? ""
        let dateAcquired = dateAcquiredTextField.text ?? ""
        let amountPaid = amountPaidTextField.text ?? ""
        let currentValue = currentValueTextField.text ?? ""
        let notes = notesTextView.text ?? ""
        let notesImage = decodedNotesImage ?? ""
        let notesImageTwo = decodedNotesTwoImage ?? ""
        let additionalInfoLabel = additionalInfoLabelTextField.text ?? ""
        let additionalInfoText = additionalInfoTextView.text ?? ""
        let additionalInfoImage = decodedAdditionalInfoImage ?? ""
        let additionalInfoImageTwo = decodedAdditionalInfoTwoImage ?? ""
        let reviewedBy = reviewedByTextField.text ?? ""
        let reviewedDate = reviewedDateTextField.text ?? ""
        let provenance = provenanceTextView.text ?? ""
        let customTitle = customTitleTextField.text ?? ""
        let additionalInfo = additionalInfoTextView.text ?? ""
        let artworkId = artwork?.id ?? ""
        let customerId = artwork?.customerId ?? ""
        let collectionId = artwork?.collectionId ?? ""
            
        updateArtwork(id: artworkId, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId)
    }
    
    @IBAction func mainImageBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func notesImageBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func NotesImageTwoBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func additionalInfoImageBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func additionalInfoImageTwoBtnPressed(_ sender: Any) {
    
    }
    
    private func updateArtwork(id: String, objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, additionalInfo: String, customerId: String, collectionId: String) {
        
        let artworkEditService = ArtworkEditService()
        
        progressHUD.show(onView: view, animated: true)
        artworkEditService.udpateArtwork(id: id, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId) { [weak self] artworkData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue editing artwork data (Artwork PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - Artwork PUT request")
                
                if let artwork = artworkData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToArtworkDetailSegue", sender: self)
                }
            }
        }
    }
}
