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
    
    var selectedArtist: String?
    var artists: [Artist] = []
    
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
        
        let fName = artists[indexPath.row].firstName ?? ""
        let lName = artists[indexPath.row].lastName ?? ""
        cell.textLabel?.text = "\(fName) \(lName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        selectedArtist = artist.id
//        selectedCustomer = customer
        
//        let customerDetailViewController = CustomerDetailViewController()
//        customerDetailViewController.customer = customer

//        self.performSegue(withIdentifier: "CustomerDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CustomerDetailSegue" {
//            let destinationVC = segue.destination as! CustomerDetailViewController
//
//            destinationVC.customer = selectedCustomer
//        }
//    }
}
