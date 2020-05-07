//
//  CollectionDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CollectionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionIdentifier: UILabel!
    @IBOutlet weak var collectionId: UILabel!
    @IBOutlet weak var artworkTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var customer: Customer?
    var customerCore: CustomerCore?
    var collection: Collection?
    var collectionCore: CollectionCore?
    var artworks: [Artwork]? = []
    var selectedArtwork: ArtworkCore?
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    var artworksCore: [ArtworkCore]? = [] {
        didSet {
            artworkTableView.reloadData()
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artworkTableView.delegate = self
        artworkTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        if let collection = collectionCore {
            collectionName.text = collection.collectionName
            collectionIdentifier.text = collection.identifier
        }
        
        artworkTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionData(_:)), for: .valueChanged)
        
        loadArtCollection()
    }
    
    private func loadArtCollection() {
        guard let collectionId = collectionCore?.id else { return }
        
        let request: NSFetchRequest<ArtworkCore> = ArtworkCore.fetchRequest()
        request.predicate = NSPredicate(format: "collectionId = %@", collectionId as NSUUID)
        
        do {
            let artworksFromCore = try context.fetch(request)
            artworksCore = artworksFromCore
        } catch {
            print("Error getting artworks from core - \(error)")
        }
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditCollectionSegue", sender: self)
    }
    
    @IBAction func unwindToCollectionViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let collection = self.collection?.id {
                    self.getCollection(collectionId: collection, refresh: false)
                }
            }
        }
    }
    
    func getCollection(collectionId: String, refresh: Bool) {
        let collectionService = CollectionService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        
        collectionService.getCollection(collectionId: collectionId) { [weak self] collectionData, error in
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
    
    @objc private func refreshCollectionData(_ sender: Any) {
        if let collection = self.collection?.id {
            getCollection(collectionId: collection, refresh: true)
        }
    }
    
    @IBAction func unwindToCollectionDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let collection = self.collection?.id {
                    self.getCollectionInfo(collectionId: collection)
                }
            }
        }
    }
    
    private func getCollectionInfo(collectionId: String) {
        let getCollectionService = GetCollectionService()
        
        progressHUD.show(onView: view, animated: true)
        getCollectionService.getCollectionInfo(collectionId: collectionId) { [weak self] collectionData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting collection info data (Collection GET request) - \(e)")
                return
            } else {
                if let collection = collectionData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.refreshCollectionInfo(collection: collection)
                }
            }
        }
    }
    
    private func refreshCollectionInfo(collection: Collection) {
        collectionName.text = collection.collectionName
        collectionIdentifier.text = collection.identifier
        collectionId.text = collection.id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworksCore?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtworkCell", for: indexPath)

        cell.textLabel?.text = self.artworksCore?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artwork = artworksCore?[indexPath.row]
        selectedArtwork = artwork

        let artworkDetailViewController = ArtworkDetailViewController()
        artworkDetailViewController.artworkCore = artwork
        
        self.performSegue(withIdentifier: "ArtworkDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtworkDetailSegue" {
            let destinationVC = segue.destination as! ArtworkDetailViewController

            destinationVC.artworkCore = selectedArtwork
        }
        
        if segue.identifier == "AddNewArtworkSegue" {
            let destinationVC = segue.destination as! ArtworkCreateViewController
            
            if let custId = customer?.id {
                destinationVC.customerId = custId
            }
            if let collId = collection?.id {
                destinationVC.collectionId = collId
            }
            
            if let custCoreId = customerCore?.id {
                destinationVC.customerCoreId = custCoreId
            }
            
            if let collCoreId = collectionCore?.id {
                destinationVC.collectionCoreId = collCoreId
            }
        }
        
        if segue.identifier == "EditCollectionSegue" {
            let destinationVC = segue.destination as! CollectionEditViewController
            
            destinationVC.customer = customer
            destinationVC.collection = collection
        }
    }
}
