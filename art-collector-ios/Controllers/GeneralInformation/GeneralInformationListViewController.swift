//
//  GeneralInformationListViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/15/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class GeneralInformationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var generalInformationsTableView: UITableView!
    
    var generalInformations: [GeneralInformation] = []
    var selectedGI: String?
    var source: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generalInformationsTableView.delegate = self
        generalInformationsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generalInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInformationListCell", for: indexPath)
        
        let id = generalInformations[indexPath.row].id
        let infoName = generalInformations[indexPath.row].infoLabel ?? ""
        
        cell.textLabel?.text = infoName
        if id == selectedGI {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gi = generalInformations[indexPath.row]
        selectedGI = gi.id

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
         
            destinationVC.selectedGeneralInfoId = selectedGI
        }
         
        if segue.identifier == "unwindToArtworkCreateSegue" {
            let destinationVC = segue.destination as! ArtworkCreateViewController
         
            destinationVC.selectedGeneralInfoId = selectedGI
        }
    }
}
