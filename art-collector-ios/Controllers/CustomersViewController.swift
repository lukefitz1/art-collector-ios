//
//  CustomersViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/24/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CustomersViewController: UIViewController {

    @IBOutlet weak var customersTableView: UITableView!

    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedCustomer: Customer?
    
    var customers: [Customer] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            customersTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Customers"
        customersTableView.delegate = self
        customersTableView.dataSource = self
        getCustomers()
    }
    
    func getCustomers() {
        customers = []
        let customerService = CustomersService()
        
        progressHUD.show(onView: view, animated: true)
        customerService.getCustomers { [weak self] customerData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting customer data (Customers GET request) - \(e)")
                return
            } else {
                print("SUCCESS - Customers GET request")
                
                if let customers = customerData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.customers = customers
                }
            }
        }
    }
}

extension CustomersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        
        cell.textLabel?.text = "\(customers[indexPath.row].firstName) \(customers[indexPath.row].lastName)"
        return cell
    }
}

extension CustomersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
        selectedCustomer = customer
        
        let customerDetailViewController = CustomerDetailViewController()
        customerDetailViewController.customer = customer
        
        // This is how to perform a segue in code only - you have to set up the view programmatically as well
        // navigationController?.pushViewController(customerDetailViewController, animated: true)
        self.performSegue(withIdentifier: "CustomerDetailSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerDetailSegue" {
            let destinationVC = segue.destination as! CustomerDetailViewController
            
            destinationVC.customer = selectedCustomer
        }
    }
}
