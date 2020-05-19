//
//  ArtworkEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtworkEditViewController: UIViewController, MultiSelectListViewControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var artwork: Artwork?
    var artworkCore: ArtworkCore?
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
    
    var artistsIds: [String] = [] {
        didSet {
             displayArtists()
        }
    }

    var generalInfoIds: [String] = [] {
        didSet {
             displayGeneralInfos()
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
        
        objectIdTextField.text = artworkCore?.objectId
        artTypeTextField.text = artworkCore?.artType
        titleTextField.text = artworkCore?.title
        dateTextField.text = artworkCore?.date
        dateTextField.text = artworkCore?.medium
        descriptionTextView.text = artworkCore?.artDescription
        dimensionsTextField.text = artworkCore?.dimensions
        frameDimensionsTextField.text = artworkCore?.frameDimensions
        conditionTextField.text = artworkCore?.condition
        currentLocationTextField.text = artworkCore?.currentLocation
        sourceTextField.text = artworkCore?.source
        dateAcquiredLabelTextField.text = artworkCore?.dateAcquiredLabel
        dateAcquiredTextField.text = artworkCore?.dateAcquired
        amountPaidTextField.text = artworkCore?.amountPaid
        currentValueTextField.text = artworkCore?.currentValue
        notesTextView.text = artworkCore?.notes
        additionalInfoLabelTextField.text = artworkCore?.additionalInfoLabel
        additionalInfoTextView.text = artworkCore?.additionalInfoText
        reviewedByTextField.text = artworkCore?.reviewedBy
        reviewedDateTextField.text = artworkCore?.reviewedDate
        provenanceTextView.text = artworkCore?.provenance
        customTitleTextField.text = artworkCore?.customTitle
        
        if let savedArtist = artworkCore?.artistIds {
            let array = savedArtist as! [String]
            artistsIds = array
        }
        
        if let savedGIs = artworkCore?.generalInfoIds {
            let array = savedGIs as! [String]
            generalInfoIds = array
        }
    }

    @IBAction func updateArtworkBtnPressed(_ sender: Any) {
        guard let artworkId = artworkCore?.id else { return }
        guard let customerId = artworkCore?.customerId else { return }
        guard let collectionId = artworkCore?.collectionId else { return }
        
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
        
        var showGeneralInfo = false
        if generalInfoIds.count > 0 {
            showGeneralInfo = true
        } else {
            showGeneralInfo = false
        }
            
        updateArtworkCoreData(id: artworkId, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, showGeneralInfo: showGeneralInfo, artists: artistsIds, generalInfos: generalInfoIds)
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
    
    @IBAction func selectMultiArtistsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "multiSelectArtistsSegueFromEdit", sender: self)
    }
    
    @IBAction func selectMultiGIsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "multiSelectGIsSegueFromEdit", sender: self)
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
        if segue.identifier == "multiSelectGIsSegueFromEdit" {
            let destinationVC = segue.destination as! MultiSelectListViewController
            destinationVC.sourceVC = "ArtworkEditViewController"
            destinationVC.dataSource = "generalInformation"
            destinationVC.delegate = self
        }

        if segue.identifier == "multiSelectArtistsSegueFromEdit" {
            let destinationVC = segue.destination as! MultiSelectListViewController
            destinationVC.sourceVC = "ArtworkEditViewController"
            destinationVC.dataSource = "artists"
            destinationVC.delegate = self
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
    
    func sendArtistData(data: [ArtistCore]) {
        var artistIdArray: [String] = []
        data.forEach { artistInfo in
            if let id = artistInfo.id?.uuidString {
                artistIdArray.append(id)
            }
        }
        
        artistsIds = artistIdArray
    }
    
    func sendGeneralInformationData(data: [GeneralInformationCore]) {
        var giIdArray: [String] = []
        data.forEach { giInfo in
            if let id = giInfo.id?.uuidString {
                giIdArray.append(id)
            }
        }
        
        generalInfoIds = giIdArray
    }
    
    private func displayArtists() {
        var artistNames: [String] = []
        artistsIds.forEach { artistId in
            if let uuidId = UUID(uuidString: artistId) {
                let artistFromCore = getArtistInfoCore(id: uuidId)
                
                if let coreArtist = artistFromCore {
                    let fName = coreArtist.firstName ?? ""
                    let lName = coreArtist.lastName ?? ""
                    
                    let name = "\(fName) \(lName)"
                    artistNames.append(name)
                }
            }
        }
        
        let artistNameDisplay = artistNames.joined(separator: ", ")
        artistNameLabel.text = artistNameDisplay
    }
    
    private func displayGeneralInfos() {
        var generalInfoLabels: [String] = []
        generalInfoIds.forEach { gi in
            if let uuidId = UUID(uuidString: gi) {
                let giFromCore = getGeneralInfoCore(id: uuidId)
                
                if let coreGI = giFromCore {
                    let giLabel = coreGI.informationLabel ?? ""
                    generalInfoLabels.append(giLabel)
                }
            }
        }
        
        let giLabelDisplay = generalInfoLabels.joined(separator: ", ")
        generalInfoLabel.text = giLabelDisplay
    }
    
    private func getArtistInfoCore(id: UUID) -> ArtistCore? {
        defer {
            self.progressHUD.hide(onView: self.view, animated: true)
        }
        
        let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)

        progressHUD.show(onView: view, animated: true)
        do {
            let artistFromCore = try context.fetch(request)
            if artistFromCore.count > 0 {
                let artist = artistFromCore[0]
                return artist
            }
        } catch {
            print("Error getting updated artist information = \(error)")
        }
        
        return nil
    }
    
    private func getGeneralInfoCore(id: UUID) -> GeneralInformationCore? {
        defer {
            self.progressHUD.hide(onView: self.view, animated: true)
        }
        
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)

        progressHUD.show(onView: view, animated: true)
        do {
            let giFromCore = try context.fetch(request)
            if giFromCore.count > 0 {
                let gi = giFromCore[0]
                return gi
            }
        } catch {
            print("Error getting updated general information = \(error)")
        }
        
        return nil
    }
    
    private func updateArtworkCoreData(id: UUID, objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, customerId: UUID, collectionId: UUID, showGeneralInfo: Bool, artists: [String], generalInfos: [String]) {
        
        let request: NSFetchRequest<ArtworkCore> = ArtworkCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        let updatedDate = DateUtility.getFormattedDateAsString()
        progressHUD.show(onView: view, animated: true)
        do {
            let artwork = try context.fetch(request)
            
            let updateArtwork = artwork[0] as NSManagedObject
            updateArtwork.setValue(updatedDate, forKey: "updatedAt")
            updateArtwork.setValue(objectId, forKey: "objectId")
            updateArtwork.setValue(artType, forKey: "artType")
            updateArtwork.setValue(title, forKey: "title")
            updateArtwork.setValue(date, forKey: "date")
            updateArtwork.setValue(medium, forKey: "medium")
            updateArtwork.setValue(description, forKey: "artDescription")
            updateArtwork.setValue(mainImage, forKey: "image")
            updateArtwork.setValue(dimensions, forKey: "dimensions")
            updateArtwork.setValue(frameDimensions, forKey: "frameDimensions")
            updateArtwork.setValue(condition, forKey: "condition")
            updateArtwork.setValue(currentLocation, forKey: "currentLocation")
            updateArtwork.setValue(source, forKey: "source")
            updateArtwork.setValue(dateAcquiredLabel, forKey: "dateAcquiredLabel")
            updateArtwork.setValue(dateAcquired, forKey: "dateAcquired")
            updateArtwork.setValue(amountPaid, forKey: "amountPaid")
            updateArtwork.setValue(currentValue, forKey: "currentValue")
            updateArtwork.setValue(notes, forKey: "notes")
            updateArtwork.setValue(notesImage, forKey: "notesImage")
            updateArtwork.setValue(notesImageTwo, forKey: "notesImageTwo")
            updateArtwork.setValue(additionalInfoLabel, forKey: "additionalInfoLabel")
            updateArtwork.setValue(additionalInfoText, forKey: "additionalInfoText")
            updateArtwork.setValue(additionalInfoImage, forKey: "additionalInfoImage")
            updateArtwork.setValue(additionalInfoImageTwo, forKey: "additionalInfoImageTwo")
            updateArtwork.setValue(reviewedBy, forKey: "reviewedBy")
            updateArtwork.setValue(reviewedDate, forKey: "reviewedDate")
            updateArtwork.setValue(provenance, forKey: "provenance")
            updateArtwork.setValue(customTitle, forKey: "customTitle")
            updateArtwork.setValue(customerId, forKey: "customerId")
            updateArtwork.setValue(collectionId, forKey: "collectionId")
            updateArtwork.setValue(showGeneralInfo, forKey: "showGeneralInfo")
            updateArtwork.setValue(artists, forKey: "artistIds")
            updateArtwork.setValue(generalInfos, forKey: "generalInfoIds")
        } catch {
            print("Error updating artwork information - \(error)")
        }
        
        saveUpdatedItem()
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.progressHUD.hide(onView: self.view, animated: true)
            self.performSegue(withIdentifier: "unwindToCollectionSegue", sender: self)
        } catch {
            self.progressHUD.hide(onView: self.view, animated: true)
            print("Error saving the updated artwork to database - \(error)")
        }
    }
}
