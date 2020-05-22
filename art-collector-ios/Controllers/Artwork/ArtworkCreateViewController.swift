//
//  ArtworkCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtworkCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MultiSelectListViewControllerDelegate {
    
    @IBOutlet weak var objectIdTextField: UITextField!
    @IBOutlet weak var artTypeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mediumTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dimensionsTextField: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
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
    @IBOutlet weak var additionalInfoImageView: UIImageView!
    @IBOutlet weak var additionalInfoImageTwoImageView: UIImageView!
    @IBOutlet weak var reviewedByTextField: UITextField!
    @IBOutlet weak var reviewedDateTextField: UITextField!
    @IBOutlet weak var provenanceTextView: UITextView!
    @IBOutlet weak var customTitleTextField: UITextField!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var addNewArtworkBtn: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var generalInfoLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let imagePicker = UIImagePickerController()
    let notesImagePicker = UIImagePickerController()
    let notesImageTwoPicker = UIImagePickerController()
    let additionalInfoImagePicker = UIImagePickerController()
    let additionalInfoTwoImagePicker = UIImagePickerController()
    
    var decodedMainImage: String?
    var decodedNotesImage: String?
    var decodedNotesTwoImage: String?
    var decodedAdditionalInfoImage: String?
    var decodedAdditionalInfoTwoImage: String?
    var customerId: String = ""
    var collectionId: String = ""
    var selectedArtistId: String?
    var selectedGeneralInfoId: String?
    var selected = 1
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var artists: [Artist] = []
    var generalInformation: [GeneralInformation] = []
    var customerCoreId: UUID = UUID()
    var collectionCoreId: UUID = UUID()
    
    var selectedGeneralInfoArray: String?
    var selectedArtistsArray: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        additionalInfoTextView.layer.borderWidth = 0.5
        additionalInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        provenanceTextView.layer.borderWidth = 0.5
        provenanceTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        objectIdTextField.delegate = self
        artTypeTextField.delegate = self
        titleTextField.delegate = self
        dateTextField.delegate = self
        dateTextField.delegate = self
        descriptionTextView.delegate = self
        dimensionsTextField.delegate = self
        frameDimensionsTextField.delegate = self
        conditionTextField.delegate = self
        currentLocationTextField.delegate = self
        sourceTextField.delegate = self
        dateAcquiredLabelTextField.delegate = self
        dateAcquiredTextField.delegate = self
        amountPaidTextField.delegate = self
        currentValueTextField.delegate = self
        notesTextView.delegate = self
        additionalInfoLabelTextField.delegate = self
        additionalInfoTextView.delegate = self
        reviewedByTextField.delegate = self
        reviewedDateTextField.delegate = self
        provenanceTextView.delegate = self
        customTitleTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func takeImageBtnPressed(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        selected = 1
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeNotesImageBtnPressed(_ sender: Any) {
        
        notesImagePicker.delegate = self
        notesImagePicker.sourceType = .camera
        notesImagePicker.allowsEditing = false
        selected = 2
        
        present(notesImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeNotesImageTwoBtnPressed(_ sender: Any) {
        
        notesImageTwoPicker.delegate = self
        notesImageTwoPicker.sourceType = .camera
        notesImageTwoPicker.allowsEditing = false
        selected = 3
        
        present(notesImageTwoPicker, animated: true, completion: nil)
    }
    
    @IBAction func additionalInfoImageBtnPressed(_ sender: Any) {
        
        additionalInfoImagePicker.delegate = self
        additionalInfoImagePicker.sourceType = .camera
        additionalInfoImagePicker.allowsEditing = false
        selected = 4
        
        present(additionalInfoImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func additionalInfoImageTwoBtnPressed(_ sender: Any) {
        
        additionalInfoTwoImagePicker.delegate = self
        additionalInfoTwoImagePicker.sourceType = .camera
        additionalInfoTwoImagePicker.allowsEditing = false
        selected = 5
        
        present(additionalInfoTwoImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectMultiGIBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "multiSelectGIsFromCreateSegue", sender: self)
    }
    
    @IBAction func selectMultiArtistsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "multiSelectArtistsFromCreateSegue", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch selected {
        case 1:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                mainImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
//                    decodedMainImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                    decodedMainImage = ArtworkCreateViewController.convertImageToBase64StringNoHeading(image: newImage)
                }
            }
        case 2:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                notesImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
//                    decodedNotesImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                    decodedNotesImage = ArtworkCreateViewController.convertImageToBase64StringNoHeading(image: newImage)
                }
            }
        case 3:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                notesImageTwoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
//                    decodedNotesTwoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                    decodedNotesTwoImage = ArtworkCreateViewController.convertImageToBase64StringNoHeading(image: newImage)
                }
            }
        case 4:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                additionalInfoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
//                    decodedAdditionalInfoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                    decodedAdditionalInfoImage = ArtworkCreateViewController.convertImageToBase64StringNoHeading(image: newImage)
                }
            }
        case 5:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                additionalInfoImageTwoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
//                    decodedAdditionalInfoTwoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                    decodedAdditionalInfoTwoImage = ArtworkCreateViewController.convertImageToBase64StringNoHeading(image: newImage)
                }
            }
        default:
            print("No image")
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewArtworkBtnPressed(_ sender: Any) {
        let objectId = objectIdTextField.text ?? ""
        let artType = artTypeTextField.text ?? ""
        let title = titleTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let medium = mediumTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
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
        let additionalInfoLabel = additionalInfoLabelTextField.text ?? ""
        let additionalInfoText = additionalInfoTextView.text ?? ""
        let reviewedBy = reviewedByTextField.text ?? ""
        let reviewedDate = reviewedDateTextField.text ?? ""
        let provenance = provenanceTextView.text ?? ""
        let customTitle = customTitleTextField.text ?? ""
        let artistId = selectedArtistId ?? ""
        let generalInfoId = selectedGeneralInfoId ?? ""
        let mainImage = decodedMainImage ?? ""
        let notesImage = decodedNotesImage ?? ""
        let notesImageTwo = decodedNotesTwoImage ?? ""
        let additionalInfoImage = decodedAdditionalInfoImage ?? ""
        let additionalInfoImageTwo = decodedAdditionalInfoTwoImage ?? ""
        
        let createDate = DateUtility.getFormattedDateAsString()
        
        var showGeneralInfo = false
        if generalInfoId != "" {
            showGeneralInfo = true
        } else {
            showGeneralInfo = false
        }
        
        createArtworkCoreData(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerCoreId, collectionId: collectionCoreId, artistId: artistId, generalInformationId: generalInfoId, showGeneralInfo: showGeneralInfo, createdAt: createDate, artists: artistsIds, generalInfos: generalInfoIds)
    }
    
    public static func convertImageToBase64String(image : UIImage ) -> String {
        let strBase64 =  image.pngData()?.base64EncodedString()
        return ("data:image/jpeg;base64,\(strBase64!)")
    }
    
    public static func convertImageToBase64StringNoHeading(image : UIImage ) -> String {
        let strBase64 =  image.pngData()?.base64EncodedString()
        return strBase64!
//        return ("data:image/jpeg;base64,\(strBase64!)")
    }
    
    @IBAction func unwindToArtworkCreateViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.setArtistName()
            }
        }
    }
    
    @IBAction func unwindToArtworkCreateFromGIViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.setGeneralInfo()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multiSelectGIsFromCreateSegue" {
            let destinationVC = segue.destination as! MultiSelectListViewController
            destinationVC.sourceVC = "ArtworkCreateViewController"
            destinationVC.dataSource = "generalInformation"
            destinationVC.delegate = self
        }
        
        if segue.identifier == "multiSelectArtistsFromCreateSegue" {
            let destinationVC = segue.destination as! MultiSelectListViewController
            destinationVC.sourceVC = "ArtworkCreateViewController"
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
    
    private func createArtworkCoreData(objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, customerId: UUID, collectionId: UUID, artistId: String, generalInformationId: String, showGeneralInfo: Bool, createdAt: String, artists: [String], generalInfos: [String]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ArtworkCore", in: context)!
        let newArt = NSManagedObject(entity: entity, insertInto: context)
        
        progressHUD.show(onView: view, animated: true)
        newArt.setValue(UUID(), forKey: "id")
        newArt.setValue(createdAt, forKey: "createdAt")
        newArt.setValue(createdAt, forKey: "updatedAt")
        newArt.setValue(objectId, forKey: "objectId")
        newArt.setValue(artType, forKey: "artType")
        newArt.setValue(title, forKey: "title")
        newArt.setValue(date, forKey: "date")
        newArt.setValue(medium, forKey: "medium")
        newArt.setValue(description, forKey: "artDescription")
        newArt.setValue(dimensions, forKey: "dimensions")
        newArt.setValue(frameDimensions, forKey: "frameDimensions")
        newArt.setValue(condition, forKey: "condition")
        newArt.setValue(currentLocation, forKey: "currentLocation")
        newArt.setValue(source, forKey: "source")
        newArt.setValue(dateAcquiredLabel, forKey: "dateAcquiredLabel")
        newArt.setValue(dateAcquired, forKey: "dateAcquired")
        newArt.setValue(amountPaid, forKey: "amountPaid")
        newArt.setValue(currentValue, forKey: "currentValue")
        newArt.setValue(notes, forKey: "notes")
        newArt.setValue(additionalInfoLabel, forKey: "additionalInfoLabel")
        newArt.setValue(additionalInfoText, forKey: "additionalInfoText")
        newArt.setValue(reviewedBy, forKey: "reviewedBy")
        newArt.setValue(reviewedDate, forKey: "reviewedDate")
        newArt.setValue(provenance, forKey: "provenance")
        newArt.setValue(customTitle, forKey: "customTitle")
        newArt.setValue(customerId, forKey: "customerId")
        newArt.setValue(collectionId, forKey: "collectionId")
        newArt.setValue(showGeneralInfo, forKey: "showGeneralInfo")
        
        // saving artist & gi arrays
        newArt.setValue(artists, forKey: "artistIds")
        newArt.setValue(generalInfos, forKey: "generalInfoIds")
        
        // saving images
        newArt.setValue(mainImage, forKey: "image")
        newArt.setValue(notesImage, forKey: "notesImage")
        newArt.setValue(notesImageTwo, forKey: "notesImageTwo")
        newArt.setValue(additionalInfoImage, forKey: "additionalInfoImage")
        newArt.setValue(additionalInfoImageTwo, forKey: "additionalInfoImageTwo")
        
        saveNewItem()
        self.progressHUD.hide(onView: self.view, animated: true)
        self.performSegue(withIdentifier: "unwindToCollectionSegue", sender: self)
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new artwork to database = \(error)")
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
}

extension ArtworkCreateViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
