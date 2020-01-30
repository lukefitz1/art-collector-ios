//
//  CollectionDetailVIewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionIdentifier: UILabel!
    @IBOutlet weak var collectionId: UILabel!
    @IBOutlet weak var artworkTableView: UITableView!
    
    var customer: Customer?
    var collection: Collection?
    var artworks: [Artwork]? = []
    var selectedArtwork: Artwork?
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Customers"
        artworkTableView.delegate = self
        artworkTableView.dataSource = self
        
        collectionName.text = collection?.collectionName
        collectionIdentifier.text = collection?.identifier
        collectionId.text = collection?.id
        
        artworkTableView.refreshControl = refreshControl
        
        if let artworksArray = collection?.artworks {
            self.artworks = artworksArray
        }
    }
    
    @IBAction func unwindToCollectionViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.getCollection(refresh: false)
            }
        }
    }
    
    func getCollection(refresh: Bool) {
        let collectionService = CollectionService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        
        collectionService.getCollection { [weak self] collectionData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting collection data (Collection GET request) - \(e)")
                return
            } else {
                if let collection = collectionData {
                    if !refresh {
                        self.progressHUD.hide(onView: self.view, animated: true)
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                    self.collection = collection
                    self.artworks = collection.artworks
                    
                    self.artworkTableView.reloadData()
                }
            }
        }
    }
}

extension CollectionDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtworkCell", for: indexPath)

        cell.textLabel?.text = self.artworks?[indexPath.row].title
        return cell
    }
}

extension CollectionDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artwork = artworks?[indexPath.row]
        selectedArtwork = artwork

        let artworkDetailViewController = ArtworkDetailViewController()
        artworkDetailViewController.artwork = artwork
        
        print("Row: \(indexPath)")
        self.performSegue(withIdentifier: "ArtworkDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtworkDetailSegue" {
            let destinationVC = segue.destination as! ArtworkDetailViewController

            destinationVC.artwork = selectedArtwork
        }
    }
}
