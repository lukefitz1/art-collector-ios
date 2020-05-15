//
//  MultiSelectListViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 5/6/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

protocol MultiSelectListViewControllerDelegate : NSObjectProtocol{
    func sendArtistData(data: [ArtistCore])
    func sendGeneralInformationData(data: [GeneralInformationCore])
}

class MultiSelectListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectDataBtn: UIButton!
    
    weak var delegate : MultiSelectListViewControllerDelegate?
    
    var sourceVC:String = ""
    var dataSource:String = ""
    
    var generalInformationsCore: [GeneralInformationCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            tableView.reloadData()
        }
    }
    
    var artistsCore: [ArtistCore] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            tableView.reloadData()
        }
    }
    
    var selectedArtists: [ArtistCore] = []
    var selectedGeneralInformation: [GeneralInformationCore] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("Source VC: \(sourceVC)")
//        print("Data Source: \(dataSource)")
        
        if dataSource == "generalInformation" {
            selectDataBtn.setTitle("Select General Information", for: .normal)
        } else if dataSource == "artists" {
            selectDataBtn.setTitle("Select Artists", for: .normal)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setup()
    }
    
    func setup() {
        if sourceVC == "ArtworkCreateViewController" {
            if dataSource == "generalInformation" {
                loadInformation(dataSource: dataSource)
            } else if dataSource == "artists" {
                loadInformation(dataSource: dataSource)
            }
        } else if sourceVC == "ArtworkEditViewController" {
            if dataSource == "generalInformation" {
                loadInformation(dataSource: dataSource)
            } else if dataSource == "artists" {
                loadInformation(dataSource: dataSource)
            }
        }
    }
    
    private func loadInformation(dataSource: String) {
        if dataSource == "generalInformation" {
            let request: NSFetchRequest<GeneralInformationCore> = GeneralInformationCore.fetchRequest()
            
            do {
                generalInformationsCore = try context.fetch(request)
            } catch {
                print("Error getting general information from core - \(error)")
            }
        } else if dataSource == "artists" {
            let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
            
            do {
                artistsCore = try context.fetch(request)
            } catch {
                print("Error fetching artist data from core - \(error)")
            }
        }
    }
    
    @IBAction func selectDataBtnTapped(_ sender: Any) {
        if let delegate = delegate {
            if dataSource == "generalInformation" {
                delegate.sendGeneralInformationData(data: selectedGeneralInformation)
            } else if dataSource == "artists" {
                delegate.sendArtistData(data: selectedArtists)
            }
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == "generalInformation" {
           return generalInformationsCore.count
        } else if dataSource == "artists" {
            return artistsCore.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)

        if dataSource == "generalInformation" {
            cell.textLabel?.text = "\(generalInformationsCore[indexPath.row].informationLabel ?? "label")"
        } else if dataSource == "artists" {
            cell.textLabel?.text = "\(artistsCore[indexPath.row].firstName ?? "test") \(artistsCore[indexPath.row].lastName ?? "test")"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            
            if dataSource == "generalInformation" {
                selectedGeneralInformation.append(generalInformationsCore[indexPath.row])
            } else if dataSource == "artists" {
                selectedArtists.append(artistsCore[indexPath.row])
            }
        } else {
            cell?.accessoryType = .none
            
            if dataSource == "generalInformation" {
                if let index = selectedGeneralInformation.firstIndex(of: generalInformationsCore[indexPath.row]) {
                    selectedGeneralInformation.remove(at: index)
                }
            } else if dataSource == "artists" {
                if let index = selectedArtists.firstIndex(of: artistsCore[indexPath.row]) {
                    selectedArtists.remove(at: index)
                }
            }
        }
        
        setButtonStatus()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setButtonStatus() {
        if dataSource == "generalInformation" {
            if selectedGeneralInformation.count > 0 {
                selectDataBtn.isEnabled = true
            } else {
                selectDataBtn.isEnabled = false
            }
        } else if dataSource == "artists" {
           if selectedArtists.count > 0 {
                selectDataBtn.isEnabled = true
            } else {
                selectDataBtn.isEnabled = false
            }
        }
    }
}
