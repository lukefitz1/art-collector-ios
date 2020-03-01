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
    
    var artwork: Artwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        objectId.text = artwork?.objectId
        artTitle.text = artwork?.title
        artType.text = artwork?.artType
    }
    
    @objc
    private func editTapped() {
//        let editGIViewController = GeneralInformationEditViewController()
//        editGIViewController.customer = customer
    
        self.performSegue(withIdentifier: "EditArworkSegue", sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       if segue.identifier == "EditGeneralInformationSegue" {
//           let destinationVC = segue.destination as! GeneralInformationEditViewController
//
//           destinationVC.customer = selectedCustomer
//       }
   }
    
}
