//
//  CustomerDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/30/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressTwo: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var collectionsTableView: UITableView!
    
    var selectedCollection: Collection?
    var customer: Customer?
    var collections: [Collection]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionsTableView.delegate = self
        collectionsTableView.dataSource = self
        
        if let cust = customer {
            firstName.text = "\(cust.firstName) \(cust.lastName)"
            
            let city = cust.city ?? ""
            let state = cust.state ?? ""
            let zip = cust.zip ?? ""
            
            address.text = cust.address ?? ""
            addressTwo.text = "\(city), \(state) \(zip)"
            phone.text = cust.phone ?? ""
            email.text = cust.email ?? ""
            id.text = cust.id
            
            if let collectionsArray = cust.collections {
                self.collections = collectionsArray
                print(collectionsArray[0].id)
            }
        }
    }
}

extension CustomerDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)

        cell.textLabel?.text = self.collections?[indexPath.row].collectionName
        return cell
    }
}

extension CustomerDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collections?[indexPath.row]
        selectedCollection = collection

        let collectionDetailViewController = CollectionDetailViewController()
        collectionDetailViewController.collection = collection
        
        self.performSegue(withIdentifier: "CollectionDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionDetailSegue" {
            let destinationVC = segue.destination as! CollectionDetailViewController

            destinationVC.customer = customer
            destinationVC.collection = selectedCollection
        }
    }
}
