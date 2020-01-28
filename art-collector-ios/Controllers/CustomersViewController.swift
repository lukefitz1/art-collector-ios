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

    private let refreshControl = UIRefreshControl()
    
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
    
    @objc private func refreshCustomerData(_ sender: Any) {
        getCustomers(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("displaying customers view")
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Customers"
        customersTableView.delegate = self
        customersTableView.dataSource = self
        
        customersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCustomerData(_:)), for: .valueChanged)
        
        getCustomers(refresh: false)
    }
    
    func getCustomers(refresh: Bool) {
        customers = []
        let customerService = CustomersService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        customerService.getCustomers { [weak self] customerData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting customer data (Customers GET request) - \(e)")
                return
            } else {
                if let customers = customerData {
                    if !refresh {
                        self.progressHUD.hide(onView: self.view, animated: true)
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                    self.customers = customers
                }
            }
        }
    }
    
    @IBAction func addNewCustomerBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func unwindToCustomersViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.getCustomers(refresh: false)
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
