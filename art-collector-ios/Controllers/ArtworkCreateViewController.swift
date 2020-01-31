//
//  ArtworkCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtworkCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var selected = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Customer: \(customerId)")
        print("Collection: \(collectionId)")
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        additionalInfoTextView.layer.borderWidth = 0.5
        additionalInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        provenanceTextView.layer.borderWidth = 0.5
        provenanceTextView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch selected {
        case 1:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                mainImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
                    decodedMainImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                }
            }
        case 2:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                notesImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
                    decodedNotesImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                }
            }
        case 3:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                notesImageTwoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
                    decodedNotesTwoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                }
            }
        case 4:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                additionalInfoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
                    decodedAdditionalInfoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
                }
            }
        case 5:
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                additionalInfoImageTwoImageView.image = image
                
                let imageData = image.jpegData(compressionQuality: 0.1)! as Data
                if let newImage = UIImage(data: imageData) {
                    decodedAdditionalInfoTwoImage = ArtworkCreateViewController.convertImageToBase64String(image: newImage)
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
        let mainImage = decodedMainImage ?? ""
//        let mainImage = ""
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
//        let notesImage = ""
        let notesImageTwo = decodedNotesTwoImage ?? ""
//        let notesImageTwo = ""
        let additionalInfoLabel = additionalInfoLabelTextField.text ?? ""
        let additionalInfoText = additionalInfoTextView.text ?? ""
        let additionalInfoImage = decodedAdditionalInfoImage ?? ""
//        let additionalInfoImage = ""
        let additionalInfoImageTwo = decodedAdditionalInfoTwoImage ?? ""
//        let additionalInfoImageTwo = ""
        let reviewedBy = reviewedByTextField.text ?? ""
        let reviewedDate = reviewedDateTextField.text ?? ""
        let provenance = provenanceTextView.text ?? ""
        let customTitle = customTitleTextField.text ?? ""
        let additionalInfo = additionalInfoTextView.text ?? ""
        
        createArtwork(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId)
        
        self.performSegue(withIdentifier: "unwindToCollectionSegue", sender: self)
    }
    
    private func createArtwork(objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, additionalInfo: String, customerId: String, collectionId: String) {
        
        let artworkCreateService = ArtworkCreateService()
        
        artworkCreateService.createArtwork(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: provenance, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId) { [weak self] artworkData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue creating artwork data (artwork POST request) - \(e)")
                return
            } else {
                print("SUCCESS - artwork request")
                
                if let artworkInfo = artworkData {
//                    print(artworkInfo)
                }
            }
        }
    }
    
    public static func  convertImageToBase64String(image : UIImage ) -> String
    {
        let strBase64 =  image.pngData()?.base64EncodedString()
        return ("data:image/jpeg;base64,\(strBase64!)")
    }
}