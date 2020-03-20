//
//  GeneralInformationViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class GeneralInformationViewController: UIViewController {
    
    @IBOutlet weak var generalInformationTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedGeneralInformation: GeneralInformation?
    var selectedGI: GeneralInformation?
    var giCoreArray: [GeneralInformationCore] = []
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
        
//        loadItems()
        getGeneralInformation(refresh: false)
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
    
    private func loadItems() {
        let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
        
        do {
            giCoreArray = try context.fetch(request)
        } catch {
            print("Error fetching general information data for core - \(error)")
        }
    }
}

extension GeneralInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generalInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInformationCell", for: indexPath)
        
        cell.textLabel?.text = "\(generalInformation[indexPath.row].infoLabel ?? "label")"
        return cell
    }
}

extension GeneralInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gi = generalInformation[indexPath.row]
        selectedGI = gi

        let giViewController = GeneralInformationDetailViewController()
        giViewController.generalInfo = selectedGI

        self.performSegue(withIdentifier: "GeneralInformationDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GeneralInformationDetailSegue" {
            let destinationVC = segue.destination as! GeneralInformationDetailViewController

            destinationVC.generalInfo = selectedGI
        }
    }
}
