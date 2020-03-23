//
//  GeneralInformationViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class GeneralInformationViewController: UIViewController {
    
    @IBOutlet weak var generalInformationTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let reachability = try! Reachability()
    let notOnlineMessage = "Syncing data requires internet access"
    let notOnlineTitle = "No Internet Access"
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedGeneralInformation: GeneralInformation?
    var selectedGI: GeneralInformation?
    var selectedGICore: GeneralInformationCore?
    var giCoreArray: [GeneralInformationCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            generalInformationTableView.reloadData()
        }
    }
    var generalInformation: [GeneralInformation] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            generalInformationTableView.reloadData()
        }
    }
    
    @objc private func refreshGeneralInformationData(_ sender: Any) {
        getGeneralInformation(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "General Information"
        generalInformationTableView.delegate = self
        generalInformationTableView.dataSource = self
        
        generalInformationTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshGeneralInformationData(_:)), for: .valueChanged)
        
        loadItems()
//        getGeneralInformation(refresh: false)
    }
    
    private func getGeneralInformation(refresh: Bool) {
        generalInformation = []
        let generalInformationService = GeneralInformationService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        generalInformationService.getGeneralInformation { [weak self] generalInformationData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting GeneralInformation data (GeneralInformation GET request) - \(e)")
                return
            } else {
                if let generalInfo = generalInformationData {
                    if !refresh {
                        self.progressHUD.hide(onView: self.view, animated: true)
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                    self.generalInformation = generalInfo
                }
            }
        }
    }
    
    @IBAction func unwindToGeneralInformationViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.getGeneralInformation(refresh: false)
            }
        }
    }
    
    @IBAction func syncGeneralInformatioData(_ sender: Any) {
        reachability.whenReachable = { _ in
            print("Online!")
            self.syncData()
        }
        
        reachability.whenUnreachable = { _ in
            print("Not online")
            let alert = UIAlertController(title: self.notOnlineTitle, message: self.notOnlineMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func syncData() {
        let generalInformationService = GeneralInformationService()
        
        progressHUD.show(onView: view, animated: true)
        generalInformationService.getGeneralInformation { [weak self] generalInformationData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting GeneralInformation data (GeneralInformation GET request) - \(e)")
                return
            } else {
                if let generalInfo = generalInformationData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.saveNetworkData(giNetworkDataArray: generalInfo)
                } else {
                    self.progressHUD.hide(onView: self.view, animated: true)
                }
            }
        }
    }
    
    private func saveNetworkData(giNetworkDataArray: [GeneralInformation]) {
        let entity = NSEntityDescription.entity(forEntityName: "GeneralInformationCore", in: context)!
//        print("GI Data Array Count: \(giNetworkDataArray.count)")
        
        // First, use the network response create
        // or update any pieces of GI
        giNetworkDataArray.forEach { gi in
            var found = false
            var foundId: String = ""
            let networkId = gi.id
//            print("Network GI Id: \(networkId)")
        
            giCoreArray.forEach { giCore in
                let coreId = giCore.id?.uuidString ?? ""
//                print("Core GI Id: \(coreId)")
                
                if networkId.caseInsensitiveCompare(coreId) == .orderedSame {
//                    print("Found a match!")
                    found = true
                    foundId = coreId
                }
            }
            
            if !found {
                let newGI = NSManagedObject(entity: entity, insertInto: context)
                let infoId = UUID(uuidString: gi.id)
                let infoLabel = gi.infoLabel
                let info = gi.information
                let infoCreatedAt = gi.createdAt
                let infoUpdatedAt = gi.updatedAt
                
                newGI.setValue(infoId, forKey: "id")
                newGI.setValue(infoCreatedAt, forKey: "createdAt")
                newGI.setValue(infoUpdatedAt, forKey: "updatedAt")
                newGI.setValue(info, forKey: "information")
                newGI.setValue(infoLabel, forKey: "informationLabel")
                
                saveNewItem()
            } else {
                let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
                let uuid = UUID(uuidString: foundId)
                
                request.predicate = NSPredicate(format: "id = %@", uuid! as NSUUID)
                do {
                    let giFromCore = try context.fetch(request)
                    
                    let updateGIManagedObject = giFromCore[0] as NSManagedObject
                    let updateGI = giFromCore[0] as GeneralInformationCore
                    
                    let networkUpdatedAt = gi.updatedAt
                    let coreUpdatedAt = updateGI.updatedAt ?? ""
                    
                    if coreUpdatedAt != networkUpdatedAt {
                        let nId = networkId
                        let cId = updateGI.id?.uuidString ?? ""
                        let cInfo = updateGI.information ?? ""
                        let cInfoLabel = updateGI.informationLabel ?? ""
                        
                        print("The updated at dates differ, let's make an update!")
//                        print("Network GI Id: \(nId)")
//                        print("Core GI Id: \(cId)")
                        print("Core Updated At: \(coreUpdatedAt)")
                        print("Network Updated At: \(networkUpdatedAt)")
                        
                        if coreUpdatedAt > networkUpdatedAt {
                            print("Core is more recent")
                            print("Let's send an update to the web app")
                            // send network request to update web app
                            
                            updateGeneralInformation(giId: cId, infoLabel: cInfoLabel, info: cInfo)
                        } else {
                            print("Network is more recent")
                            print("Let's update local database")
                            
                            // update core with latest GI
                            let networkInfoLabel = gi.infoLabel
                            let networkInfo = gi.information
                            
                            updateGIManagedObject.setValue(networkUpdatedAt, forKey: "updatedAt")
                            updateGIManagedObject.setValue(networkInfoLabel, forKey: "informationLabel")
                            updateGIManagedObject.setValue(networkInfo, forKey: "information")
                            
                            saveNewItem()
                        }
                    } else {
//                        print("No difference, no updates necessary")
                    }
                } catch {
                    print("Error updating general information = \(error)")
                }
            }
            
            found = false
            foundId = ""
        }
        
        // Next, let's send any locally created
        // pieces of GI to the web app
        
        // TODO
    
        // reload table data
        loadItems()
        
        reachability.stopNotifier()
    }
    
    private func updateGeneralInformation(giId: String, infoLabel: String, info: String) {
        let giEditService = GeneralInformationEditService()
        
        progressHUD.show(onView: view, animated: true)
        giEditService.updateGeneralInformation(id: giId, infoLabel: infoLabel, info: info) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue editing GI data (GI PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - GI PUT request")
                
                if let generalInfo = giData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                }
            }
        }
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new GIs to database = \(error)")
        }
    }
    
    private func loadItems() {
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        
        do {
            giCoreArray = try context.fetch(request)
//            generalInformation = try context.fetch(request)
        } catch {
            print("Error fetching general information data for core - \(error)")
        }
    }
}

extension GeneralInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return generalInformation.count
        return giCoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInformationCell", for: indexPath)
        
//        cell.textLabel?.text = "\(generalInformation[indexPath.row].infoLabel ?? "label")"
        cell.textLabel?.text = "\(giCoreArray[indexPath.row].informationLabel ?? "label")"
        return cell
    }
}

extension GeneralInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let gi = generalInformation[indexPath.row]
//        selectedGI = gi

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

//            destinationVC.generalInfo = selectedGI
            destinationVC.generalInfoCore = selectedGICore
        }
    }
}
