//
//  ArtworkDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtworkDetailViewController: UIViewController {
    
    @IBOutlet weak var objectId: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    @IBOutlet weak var artType: UILabel!
    @IBOutlet weak var mainImageImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var frameDimensionsLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateAcquiredLabelLabel: UILabel!
    @IBOutlet weak var dateAcquiredLabel: UILabel!
    @IBOutlet weak var amountPaidLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesImageImageView: UIImageView!
    @IBOutlet weak var notesImageTwoImageView: UIImageView!
    @IBOutlet weak var additionalInfoLabelLabel: UILabel!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var additionalInfoImageImageView: UIImageView!
    @IBOutlet weak var additionalInfoImageTwoImageView: UIImageView!
    @IBOutlet weak var reviewedByLabel: UILabel!
    @IBOutlet weak var reviewedDateLabel: UILabel!
    @IBOutlet weak var provenanceTextView: UITextView!
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var generalInfoNameLabel: UILabel!
    
    var artwork: Artwork?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var artist: Artist? {
        didSet {
            if let fName = artist?.firstName {
                if let lName = artist?.lastName {
                    artistNameLabel.text = "\(fName) \(lName)"
                }
            }
        }
    }
    var generalInfo: GeneralInformation? {
        didSet {
            if let label = generalInfo?.infoLabel {
                generalInfoNameLabel.text = label
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        additionalInfoTextView.layer.borderWidth = 0.5
        additionalInfoTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        provenanceTextView.layer.borderWidth = 0.5
        provenanceTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        objectId.text = artwork?.objectId
        artTitle.text = artwork?.title
        artType.text = artwork?.artType
        dateLabel.text = artwork?.date
        mediumLabel.text = artwork?.medium
        descriptionTextView.text = artwork?.description
        dimensionsLabel.text = artwork?.dimensions
        frameDimensionsLabel.text = artwork?.frameDimensions
        conditionLabel.text = artwork?.condition
        currentLocationLabel.text = artwork?.currentLocation
        sourceLabel.text = artwork?.source
        dateAcquiredLabelLabel.text = artwork?.dateAcquiredLabel
        dateAcquiredLabel.text = artwork?.dateAcquired
        amountPaidLabel.text = artwork?.amountPaid
        currentValueLabel.text = artwork?.currentValue
        notesTextView.text = artwork?.notes
        additionalInfoLabelLabel.text = artwork?.additionalInfoLabel
        additionalInfoTextView.text = artwork?.additionalInfoText
        reviewedByLabel.text = artwork?.reviewedBy
        reviewedDateLabel.text = artwork?.reviewedDate
        provenanceTextView.text = artwork?.provenance
        customTitleLabel.text = artwork?.customTitle
        
        
        if let imageUrl = artwork?.image?.url {
            setImage(from: imageUrl, imageType: "mainImage")
        }
        
        if let imageUrl = artwork?.notesImage?.url {
            setImage(from: imageUrl, imageType: "notesImage")
        }
        
        if let imageUrl = artwork?.notesImageTwo?.url {
            setImage(from: imageUrl, imageType: "notesImageTwo")
        }
        
        if let imageUrl = artwork?.additionalInfoImage?.url {
            setImage(from: imageUrl, imageType: "addInfoImage")
        }
        
        if let imageUrl = artwork?.additionalInfoImageTwo?.url {
            setImage(from: imageUrl, imageType: "addInfoImageTwo")
        }
        
        if let artistId = artwork?.artistId {
            self.getArtistInfo(id: artistId)
        } else {
            artistNameLabel.text = ""
        }
        
        if let generalInfoId = artwork?.generalInfoId {
            self.getGeneralInfo(id: generalInfoId)
        } else {
            generalInfoNameLabel.text = ""
        }
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditArworkSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "EditArworkSegue" {
           let destinationVC = segue.destination as! ArtworkEditViewController

           destinationVC.artwork = artwork
       }
    }
    
    @IBAction func unwindToArtworkDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let art = self.artwork?.id {
                    self.getArtworkInfo(artId: art)
                }
            }
        }
    }
    
    private func getArtworkInfo(artId: String) {
        let getArtworkService = GetArtworkService()

        progressHUD.show(onView: view, animated: true)
        getArtworkService.getArtworkInfo(artworkId: artId) { [weak self] artData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting artwork info data (Artwork GET request) - \(e)")
                return
            } else {
                if let art = artData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.artwork = art
                    self.refreshArtwork(artwork: art)
                }
            }
        }
    }
    
    private func getArtistInfo(id: String) {
        let getArtistService = GetArtistService()
        
        getArtistService.getArtistInfo(artistId: id) { [weak self] artistData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting artist info data (Artist GET request) - \(e)")
                return
            } else {
                if let artist = artistData {
                    self.artist = artist
                }
            }
        }
    }
    
    private func getGeneralInfo(id: String) {
        let getGeneralInfoService = GetGeneralInformationService()
        
        getGeneralInfoService.getGeneralInfo(giId: id){ [weak self] giData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting GI info data (General Info GET request) - \(e)")
                return
            } else {
                if let gi = giData {
                    self.generalInfo = gi
                }
            }
        }
    }
    
    private func refreshArtwork(artwork: Artwork) {
        objectId.text = artwork.objectId
        artTitle.text = artwork.title
        artType.text = artwork.artType
        dateLabel.text = artwork.date
        mediumLabel.text = artwork.medium
        descriptionTextView.text = artwork.description
        dimensionsLabel.text = artwork.dimensions
        frameDimensionsLabel.text = artwork.frameDimensions
        conditionLabel.text = artwork.condition
        currentLocationLabel.text = artwork.currentLocation
        sourceLabel.text = artwork.source
        dateAcquiredLabelLabel.text = artwork.dateAcquiredLabel
        dateAcquiredLabel.text = artwork.dateAcquired
        amountPaidLabel.text = artwork.amountPaid
        currentValueLabel.text = artwork.currentValue
        notesTextView.text = artwork.notes
        additionalInfoLabelLabel.text = artwork.additionalInfoLabel
        additionalInfoTextView.text = artwork.additionalInfoText
        provenanceTextView.text = artwork.provenance
        customTitleLabel.text = artwork.customTitle

        if let id = artwork.artistId {
            getArtistInfo(id: id)
        }
        
        if let giId = artwork.generalInfoId {
            getGeneralInfo(id: giId)
        }
    }
    
    private func setImage(from url: String, imageType: String) {
        guard let imageURL = URL(string: url) else { return }

        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                switch imageType {
                case "mainImage":
                    self.mainImageImageView.image = image
                case "notesImage":
                    self.notesImageImageView.image = image
                case "notesImageTwo":
                    self.notesImageTwoImageView.image = image
                case "addInfoImage":
                    self.additionalInfoImageImageView.image = image
                case "addInfoImageTwo":
                    self.additionalInfoImageTwoImageView.image = image
                default:
                    return
                }
            }
        }
    }
}
