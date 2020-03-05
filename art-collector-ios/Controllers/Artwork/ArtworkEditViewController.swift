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
}
