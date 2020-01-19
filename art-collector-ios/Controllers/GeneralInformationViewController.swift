//
//  GeneralInformationViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class GeneralInformationViewController: UIViewController {
    
    @IBOutlet weak var generalInformationTableView: UITableView!
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedGeneralInformation: GeneralInformation?
    
    var generalInformation: [GeneralInformation] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            generalInformationTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "General Information"
//        generalInformationTableView.delegate = self
        generalInformationTableView.dataSource = self
        getGeneralInformation()
    }
    
    private func getGeneralInformation() {
        generalInformation = []
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
                print("SUCCESS - GeneralInformation GET request")
                
                if let generalInfo = generalInformationData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.generalInformation = generalInfo
                }
            }
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
