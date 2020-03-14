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
    
    var artwork: Artwork?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        objectId.text = artwork?.objectId
        artTitle.text = artwork?.title
        artType.text = artwork?.artType
        
        if let imageUrl = artwork?.image?.url {
            setImage(from: imageUrl)
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
                    self.refreshArtwork(artwork: art)
                }
            }
        }
    }
    
    private func refreshArtwork(artwork: Artwork) {
        objectId.text = artwork.objectId
        artTitle.text = artwork.title
        artType.text = artwork.artType
    }
    
    private func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.mainImageImageView.image = image
            }
        }
    }
}
