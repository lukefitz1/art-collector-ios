//
//  ArtistsViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController {
    
    @IBOutlet weak var artistsTableView: UITableView!
    
    var selectedCustomer: Artist?
    
    var artists: [Artist] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            artistsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Artists"
        
//        artistsTableView.delegate = self
        artistsTableView.dataSource = self
        getArtists()
    }
    
    @objc func newArtist() {
        print("Button pressed")
    }
    
    func getArtists() {
        artists = []
        let artistService = ArtistsService()
        
        artistService.getArtists { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting artist data (Artists GET request) - \(e)")
                return
            } else {
                print("SUCCESS - Artists GET request")
                
                if let artists = artistData {
                    self.artists = artists
                }
            }
        }
    }
    
    @IBAction func addArtist(_ sender: Any) {
        print("buttonPressed")
    }
    
    @IBAction func unwindToArtistsViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
//                self.tableView.reloadData()s
//                print("Unwinding the segue!!")
//                self.artistsTableView.reloadData()
                self.getArtists()
            }
        }
    }
}

extension ArtistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        
        cell.textLabel?.text = "\(artists[indexPath.row].firstName ?? "test") \(artists[indexPath.row].lastName ?? "test")"
        return cell
    }
}

//extension ArtistsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let customer = customers[indexPath.row]
//        selectedCustomer = customer
//
//        let customerDetailViewController = CustomerDetailViewController()
//        customerDetailViewController.customer = customer
//
//        // This is how to perform a segue in code only - you have to set up the view programmatically as well
//        // navigationController?.pushViewController(customerDetailViewController, animated: true)
//        self.performSegue(withIdentifier: "CustomerDetailSegue", sender: self)
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CustomerDetailSegue" {
//            let destinationVC = segue.destination as! CustomerDetailViewController
//
//            destinationVC.customer = selectedCustomer
//        }
//    }
//}
