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
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionsTableView.delegate = self
        collectionsTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        if let cust = customer {
            firstName.text = "\(cust.firstName) \(cust.lastName)"
            phone.text = cust.phone ?? ""
            email.text = cust.email ?? ""
            id.text = cust.id
            address.text = cust.address ?? ""
            
            let zip = cust.zip ?? ""
            if let city = cust.city {
                if let state = cust.state {
                    addressTwo.text = "\(city), \(state) \(zip)"
                } else {
                    addressTwo.text = "\(city), \(zip)"
                }
            } else {
                addressTwo.text = ""
            }
            
            if let collectionsArray = cust.collections {
                self.collections = collectionsArray
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc
    private func editTapped() {
        print("Edit button tapped")
    }
    
    @IBAction func unwindToCustomerDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let customer = self.customer?.id {
                    self.getCustomer(customerId: customer, refresh: false)
                }
            }
        }
    }
    
    private func getCustomer(customerId: String, refresh: Bool) {
        let getCustomerService = GetCustomerService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        
        getCustomerService.getCustomer(customerId: customerId) { [weak self] customerData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting customer data (Customer GET request) - \(e)")
                return
            } else {
                if let customer = customerData {
                    if !refresh {
                        self.progressHUD.hide(onView: self.view, animated: true)
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                    
                    self.collections = customer.collections
                    self.collectionsTableView.reloadData()
                }
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
        
        if segue.identifier == "AddNewCollectionSegue" {
            print("AddNewCollectionSegue")
            
            let destinationVC = segue.destination as! CollectionCreateViewController
            
            if let custId = customer?.id {
                destinationVC.customerId = custId
            }
        }
    }
}
