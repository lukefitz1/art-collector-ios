//
//  ArtistListViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/14/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artistsTableView: UITableView!
    
    var artists: [Artist] = []
    var selectedArtist: String?
    var source: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistListCell", for: indexPath)
        
        let id = artists[indexPath.row].id
        let fName = artists[indexPath.row].firstName ?? ""
        let lName = artists[indexPath.row].lastName ?? ""
        
        cell.textLabel?.text = "\(fName) \(lName)"
        if id == selectedArtist {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        selectedArtist = artist.id

        if source == "ArtworkEditViewController" {
            self.performSegue(withIdentifier: "unwindToArtworkEditSegue", sender: self)
        } else if source == "ArtworkCreateViewController" {
            self.performSegue(withIdentifier: "unwindToArtworkCreateSegue", sender: self)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToArtworkEditSegue" {
            let destinationVC = segue.destination as! ArtworkEditViewController
            
            destinationVC.selectedArtistId = selectedArtist
        }
        
        if segue.identifier == "unwindToArtworkCreateSegue" {
           let destinationVC = segue.destination as! ArtworkCreateViewController
            
           destinationVC.selectedArtistId = selectedArtist
       }
    }
}
