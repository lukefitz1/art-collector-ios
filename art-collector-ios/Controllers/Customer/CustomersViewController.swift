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

    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://spire-art-services.herokuapp.com/")
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
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
        
        print("Data file path: \(dataFilePath)")
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
    
    @IBAction func addNewCustomerBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func unwindToCustomersViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
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
