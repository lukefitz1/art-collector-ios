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
    
    @IBOutlet weak var objectId: UITextField!
    @IBOutlet weak var artType: UITextField!
    @IBOutlet weak var artTitle: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var medium: UITextField!
    @IBOutlet weak var artDescription: UITextView!
    @IBOutlet weak var dimensions: UITextField!
    @IBOutlet weak var frameDimensions: UITextField!
    @IBOutlet weak var condition: UITextField!
    @IBOutlet weak var currentLocation: UITextField!
    @IBOutlet weak var source: UITextField!
    @IBOutlet weak var dateAcquiredLabel: UITextField!
    @IBOutlet weak var dateAcquired: UITextField!
    @IBOutlet weak var amountPaid: UITextField!
    @IBOutlet weak var currentValue: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var additionalInfoLabel: UITextField!
    @IBOutlet weak var additionalInfo: UITextView!
    @IBOutlet weak var reviewedBy: UITextField!
    @IBOutlet weak var reviewedDate: UITextField!
    @IBOutlet weak var provenance: UITextView!
    @IBOutlet weak var customTitle: UITextField!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var notesImage: UIImageView!
    @IBOutlet weak var notesImageTwo: UIImageView!
    @IBOutlet weak var additionalInfoImage: UIImageView!
    @IBOutlet weak var additionalInfoImageTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objectId.text = artwork?.objectId
        artType.text = artwork?.artType
        artTitle.text = artwork?.title
        date.text = artwork?.date
        medium.text = artwork?.medium
        artDescription.text = artwork?.description
        dimensions.text = artwork?.dimensions
        frameDimensions.text = artwork?.frameDimensions
        condition.text = artwork?.condition
        currentLocation.text = artwork?.currentLocation
        source.text = artwork?.source
        dateAcquiredLabel.text = artwork?.dateAcquiredLabel
        dateAcquired.text = artwork?.dateAcquired
        amountPaid.text = artwork?.amountPaid
        currentValue.text = artwork?.currentValue
        notes.text = artwork?.notes
        additionalInfoLabel.text = artwork?.additionalInfoLabel
        additionalInfo.text = artwork?.additionalInfoText
        reviewedBy.text = artwork?.reviewedBy
        reviewedDate.text = artwork?.reviewedDate
        provenance.text = artwork?.provenance
        customTitle.text = artwork?.customTitle
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
