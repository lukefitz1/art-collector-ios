//
//  GeneralInformationViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class GeneralInformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var generalInformationTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://spire-art-services.herokuapp.com/")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notOnlineMessage = "Syncing data requires internet access"
    let notOnlineTitle = "No Internet Access"
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedGeneralInformation: GeneralInformation?
    var selectedGICore: GeneralInformationCore?
    var giCoreArray: [GeneralInformationCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            generalInformationTableView.reloadData()
        }
    }
    
    @objc private func refreshGeneralInformationData(_ sender: Any) {
//        getGeneralInformation(refresh: true)
        print("TODO - Add in refresh from core data")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        loadItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "General Information"
        generalInformationTableView.delegate = self
        generalInformationTableView.dataSource = self
        
        generalInformationTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshGeneralInformationData(_:)), for: .valueChanged)
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
    
    @IBAction func unwindToGeneralInformationViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadItems()
            }
        }
    }
    
    @IBAction func syncGeneralInformatioData(_ sender: Any) {
        if checkReachable() {
            self.syncData()
        } else {
            let alert = UIAlertController(title: notOnlineTitle, message: notOnlineMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        
        do {
            giCoreArray = try context.fetch(request)
        } catch {
            print("Error fetching general information data for core - \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giCoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInformationCell", for: indexPath)
        
        cell.textLabel?.text = "\(giCoreArray[indexPath.row].informationLabel ?? "label")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gi = giCoreArray[indexPath.row]
        selectedGICore = gi
        
        let giViewController = GeneralInformationDetailViewController()
        giViewController.generalInfoCore = selectedGICore

        self.performSegue(withIdentifier: "GeneralInformationDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GeneralInformationDetailSegue" {
            let destinationVC = segue.destination as! GeneralInformationDetailViewController

            destinationVC.generalInfoCore = selectedGICore
        }
    }
}
