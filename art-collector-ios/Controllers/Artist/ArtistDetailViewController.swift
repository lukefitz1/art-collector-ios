//
//  ArtistDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ArtistDetailViewController: UIViewController {
    
    @IBOutlet weak var artistImageImageView: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var artistInfo: UILabel!
    @IBOutlet weak var biography: UILabel!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var artist: Artist?
    var artistCore: ArtistCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        firstName.text = artistCore?.firstName
        lastName.text = artistCore?.lastName
        artistInfo.text = artistCore?.additionalInfo
        biography.text = artistCore?.biography
        
        // TODO - Image for artist
//        if let imageUrl = artistCore?.artistImage?.thumb?.url {
//            setImage(from: imageUrl)
//        }
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditArtistSegue", sender: self)
    }
    
    @IBAction func unwindToArtistDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let artist = self.artistCore?.id {
                    self.getArtistInfoCore(id: artist)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditArtistSegue" {
            let destinationVC = segue.destination as! ArtistEditViewController
            
            destinationVC.artistCore = artistCore
        }
    }
    
    private func getArtistInfoCore(id: UUID) {
            let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as NSUUID)

            progressHUD.show(onView: view, animated: true)
            do {
                let artist = try context.fetch(request)
                let updatedArtist = artist[0] as ArtistCore
                refreshArtistInfoCore(artist: updatedArtist)
            } catch {
                print("Error getting updated artist information = \(error)")
            }
            self.progressHUD.hide(onView: self.view, animated: true)
        }
    
    private func refreshArtistInfoCore(artist: ArtistCore) {
        firstName.text = artist.firstName
        lastName.text = artist.lastName
        artistInfo.text = artist.additionalInfo
        biography.text = artist.biography
    }
    
    private func refreshArtistInfo(artist: Artist) {
        firstName.text = artist.firstName
        lastName.text = artist.lastName
        artistInfo.text = artist.additionalInfo
        biography.text = artist.biography
    }
    
    private func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.artistImageImageView.image = image
            }
        }
    }
    
//    private func getArtistInfo(artistId: String) {
//        let getArtistService = GetArtistService()
//
//        progressHUD.show(onView: view, animated: true)
//        getArtistService.getArtistInfo(artistId: artistId) { [weak self] artistData, error in
//            guard let self = self else {
//                return
//            }
//
//            if let e = error {
//                print("Issue getting artist info data (Artist GET request) - \(e)")
//                return
//            } else {
//                if let artist = artistData {
//                    self.progressHUD.hide(onView: self.view, animated: true)
//                    self.refreshArtistInfo(artist: artist)
//                }
//            }
//        }
//    }
}
