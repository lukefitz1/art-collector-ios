//
//  ArtistDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistDetailViewController: UIViewController {
    
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var artistInfo: UILabel!
    @IBOutlet weak var biography: UILabel!

    var artist: Artist?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        firstName.text = artist?.firstName
        lastName.text = artist?.lastName
        artistInfo.text = artist?.additionalInfo
        biography.text = artist?.biography
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditArtistSegue", sender: self)
    }
    
    @IBAction func unwindToArtistDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let artist = self.artist?.id {
                    self.getArtistInfo(artistId: artist)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditArtistSegue" {
            let destinationVC = segue.destination as! ArtistEditViewController
            
            destinationVC.artist = artist
        }
    }
    
    private func getArtistInfo(artistId: String) {
        let getArtistService = GetArtistService()
        
        progressHUD.show(onView: view, animated: true)
        getArtistService.getArtistInfo(artistId: artistId) { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting artist info data (Artist GET request) - \(e)")
                return
            } else {
                if let artist = artistData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.refreshArtistInfo(artist: artist)
                }
            }
        }
    }
    
    private func refreshArtistInfo(artist: Artist) {
        firstName.text = artist.firstName
        lastName.text = artist.lastName
        artistInfo.text = artist.additionalInfo
        biography.text = artist.biography
    }
}
