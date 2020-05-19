//
//  ArtistsViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class ArtistsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artistsTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://spire-art-services.herokuapp.com/")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notOnlineMessage = "Syncing data requires internet access"
    let notOnlineTitle = "No Internet Access"
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedArtistCore: ArtistCore?
    var artistsCoreArray: [ArtistCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            artistsTableView.reloadData()
        }
    }
    
    @objc private func refreshArtistsData(_ sender: Any) {
//        getArtists(refresh: true)
        print("TODO - refresh artist data")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
        loadItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Artists"
        
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
        
        artistsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArtistsData(_:)), for: .valueChanged)
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
    
    @IBAction func unwindToArtistsViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadItems()
            }
        }
    }
    
    @IBAction func syncArtistDataBtnPressed(_ sender: Any) {
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
        let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
        
        do {
            artistsCoreArray = try context.fetch(request)
        } catch {
            print("Error fetching artist data from core - \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsCoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        
        cell.textLabel?.text = "\(artistsCoreArray[indexPath.row].firstName ?? "test") \(artistsCoreArray[indexPath.row].lastName ?? "test")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artistsCoreArray[indexPath.row]
        selectedArtistCore = artist

        let artistDetailViewController = ArtistDetailViewController()
        artistDetailViewController.artistCore = selectedArtistCore

        self.performSegue(withIdentifier: "ArtistDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtistDetailSegue" {
            let destinationVC = segue.destination as! ArtistDetailViewController

            destinationVC.artistCore = selectedArtistCore
        }
    }
}
