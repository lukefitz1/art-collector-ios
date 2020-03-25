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
    var selectedArtistId: String?
    var selectedGeneralInfoId: String?
    var artists: [Artist] = [] {
        didSet {
            setArtistName()
        }
    }
    var generalInformation: [GeneralInformation] = [] {
        didSet {
            setGeneralInfo()
        }
    }
    
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
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var generalInfoLabel: UILabel!
    
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
        
        if let artistId = artwork?.artistId {
            selectedArtistId = artistId
        } else {
            artistNameLabel.text = ""
        }
        
        if let giId = artwork?.generalInfoId {
            selectedGeneralInfoId = giId
        } else {
            generalInfoLabel.text = ""
        }
        
        getArtists()
        getGeneralInformation()
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
        let artworkId = artwork?.id ?? ""
        let customerId = artwork?.customerId ?? ""
        let collectionId = artwork?.collectionId ?? ""
        let artistId = selectedArtistId ?? ""
        let generalInfoId = selectedGeneralInfoId ?? ""
        
        var showGeneralInfo = false
        if generalInfoId != "" {
            showGeneralInfo = true
        } else {
            showGeneralInfo = false
        }
            
//        updateArtwork(id: artworkId, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, artistId: artistId, generalInformationId: generalInfoId, showGeneralInfo: showGeneralInfo)
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
    
    @IBAction func selectArtistBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "viewArtistListFromEdit", sender: self)
    }
    
    @IBAction func selectGeneralInformationBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "viewGIListFromEdit", sender: self)
    }
    
    private func getArtists() {
        let getArtistsService = ArtistsService()
        
        getArtistsService.getArtists { [weak self] artistData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting artist info data (Artist GET request) - \(e)")
                return
            } else {
                if let artists = artistData {
                    self.artists = artists
                }
            }
        }
    }
    
    private func getGeneralInformation() {
        let getGeneralInformationService = GeneralInformationService()
        
        getGeneralInformationService.getGeneralInformation() { [weak self] generalInformationData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting general info data (General Info GET request) - \(e)")
                return
            } else {
                if let gi = generalInformationData {
                    self.generalInformation = gi
                }
            }
        }
    }
    
    @IBAction func unwindToArtworkEditViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.setArtistName()
            }
        }
    }
    
    @IBAction func unwindToArtworkEditFromGIViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.setGeneralInfo()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewArtistListFromEdit" {
            let destinationVC = segue.destination as! ArtistListViewController

            destinationVC.artists = artists
            destinationVC.source = "ArtworkEditViewController"
            
            if let artistId = selectedArtistId {
                destinationVC.selectedArtist = artistId
            }
        }
        
        if segue.identifier == "viewGIListFromEdit" {
            let destinationVC = segue.destination as! GeneralInformationListViewController

            destinationVC.generalInformations = generalInformation
            destinationVC.source = "ArtworkEditViewController"
            
            if let giId = selectedGeneralInfoId {
                destinationVC.selectedGI = giId
            }
        }
    }
    
    private func setArtistName() {
        if let artist = self.artists.first(where: { $0.id == self.selectedArtistId }) {
            let fName = artist.firstName ?? ""
            let lName = artist.lastName ?? ""
            
            self.artistNameLabel.text = "\(fName) \(lName)"
        }
    }
    
    private func setGeneralInfo() {
        if let gi = self.generalInformation.first(where: { $0.id == self.selectedGeneralInfoId }) {
            let infoLabel = gi.infoLabel ?? ""
            
            self.generalInfoLabel.text = infoLabel
        }
    }
    
//    private func updateArtwork(id: String, objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, customerId: String, collectionId: String, artistId: String, generalInformationId: String, showGeneralInfo: Bool) {
//
//        let artworkEditService = ArtworkEditService()
//
//        progressHUD.show(onView: view, animated: true)
//        artworkEditService.udpateArtwork(id: id, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, artistId: artistId, generalInformationId: generalInformationId, showGeneralInfo: showGeneralInfo) { [weak self] artworkData, error in
//            guard let self = self else {
//                return
//            }
//
//            if let e = error {
//                print("Issue editing artwork data (Artwork PUT request) - \(e)")
//                return
//            } else {
//                print("SUCCESS - Artwork PUT request")
//
//                if let artwork = artworkData {
//                    self.progressHUD.hide(onView: self.view, animated: true)
//                    self.performSegue(withIdentifier: "unwindToArtworkDetailSegue", sender: self)
//                }
//            }
//        }
//    }
}
