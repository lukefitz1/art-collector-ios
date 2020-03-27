//
//  CustomersViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/24/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class CustomersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var customersTableView: UITableView!

    private let refreshControl = UIRefreshControl()
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://spire-art-services.herokuapp.com/")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notOnlineMessage = "Syncing data requires internet access"
    let notOnlineTitle = "No Internet Access"
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedCustomer: Customer?
    var selectedCustomerCore: CustomerCore?
    var customersCoreArray: [CustomerCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            customersTableView.reloadData()
        }
    }
    
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
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
        loadItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Customers"
        customersTableView.delegate = self
        customersTableView.dataSource = self
        
        customersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCustomerData(_:)), for: .valueChanged)
    }
    
    private func checkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags))
        {
            print (flags)
            if flags.contains(.isWWAN) {
                return true
            }
            
            return true
        }
        else if (!isNetworkReachable(with: flags)) {
            return false
        }
        return false
    }

    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    @IBAction func syncCustomerDataBtnPressed(_ sender: Any) {
        if checkReachable() {
            self.syncData()
        } else {
            let alert = UIAlertController(title: notOnlineTitle, message: notOnlineMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
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
//                self.getCustomers(refresh: false)
                self.loadItems()
            }
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<CustomerCore> = CustomerCore.fetchRequest()
        
        do {
            customersCoreArray = try context.fetch(request)
        } catch {
            print("Error fetching customer data from core - \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customersCoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        
        let firstName = customersCoreArray[indexPath.row].firstName ?? ""
        let lastName = customersCoreArray[indexPath.row].lastName ?? ""
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customersCoreArray[indexPath.row]
        selectedCustomerCore = customer
        
        let customerDetailViewController = CustomerDetailViewController()
        customerDetailViewController.customerCore = customer
        
        self.performSegue(withIdentifier: "CustomerDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerDetailSegue" {
            let destinationVC = segue.destination as! CustomerDetailViewController
            
            destinationVC.customerCore = selectedCustomerCore
        }
    }
}
