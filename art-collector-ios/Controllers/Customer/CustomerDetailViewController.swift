//
//  CustomerDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/30/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CustomerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressTwo: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var collectionsTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCollection: Collection?
    var customer: Customer?
    var customerCore: CustomerCore?
    var collections: [Collection]? = []
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionsTableView.delegate = self
        collectionsTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        if let cust = customerCore {
            let fName = cust.firstName ?? ""
            let lName = cust.lastName ?? ""
            
            firstName.text = "\(fName) \(lName)"
            
            phone.text = cust.phoneNumber ?? ""
            email.text = cust.emailAddress ?? ""
//            id.text = cust.id
            address.text = cust.streetAddress ?? ""
            
            let addTwo = AddressUtility.getFormattedAddressTwo(customer: cust)
            addressTwo.text = addTwo

//            if let collectionsArray = cust.collections {
//                self.collections = collectionsArray
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc
    private func editTapped() {
        self.performSegue(withIdentifier: "EditCustomerSegue", sender: self)
    }
    
    @IBAction func unwindToCustomerDetailViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let customer = self.customerCore?.id {
                    self.getCustomerInfoCore(id: customer)
                }
            }
        }
    }
    
    private func getCustomerInfoCore(id: UUID) {
        let request: NSFetchRequest<CustomerCore> = CustomerCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)

        progressHUD.show(onView: view, animated: true)
        do {
            let customer = try context.fetch(request)
            let updatedCustomer = customer[0] as CustomerCore
            refreshCustomerInfoCore(customer: updatedCustomer)
        } catch {
            print("Error getting updated customer information = \(error)")
        }
        self.progressHUD.hide(onView: self.view, animated: true)
    }
    
    private func refreshCustomerInfoCore(customer: CustomerCore) {
        let fName = customer.firstName ?? ""
        let lName = customer.lastName ?? ""
        
        if firstName.text != "\(fName) \(lName)" {
            firstName.text = "\(fName) \(lName)"
        }

        if phone.text != customer.phoneNumber {
            phone.text = customer.phoneNumber
        }
        
        if email.text != customer.emailAddress {
            email.text = customer.emailAddress
        }
        
        if address.text != customer.streetAddress {
            address.text = customer.streetAddress
        }
        
        let addTwo = AddressUtility.getFormattedAddressTwo(customer: customer)
        addressTwo.text = addTwo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)

        cell.textLabel?.text = self.collections?[indexPath.row].collectionName
        return cell
    }
    
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
            let destinationVC = segue.destination as! CollectionCreateViewController
            
            if let custId = customer?.id {
                destinationVC.customerId = custId
            }
        }
        
        if segue.identifier == "EditCustomerSegue" {
            let destinationVC = segue.destination as! CustomerEditViewController
            
            destinationVC.customerCore = customerCore
        }
    }
}
