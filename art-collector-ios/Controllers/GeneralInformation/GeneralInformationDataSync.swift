//
//  GeneralInformationDataSync.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/24/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

extension GeneralInformationViewController {
    
    func syncData() {
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
    
    func saveNetworkData(giNetworkDataArray: [GeneralInformation]) {
        let entity = NSEntityDescription.entity(forEntityName: "GeneralInformationCore", in: context)!
        
        // First, use the network response create
        // or update any pieces of GI
        giNetworkDataArray.forEach { gi in
            var found = false
            var foundId: String = ""
            let networkId = gi.id
        
            giCoreArray.forEach { giCore in
                let coreId = giCore.id?.uuidString ?? ""
                
                if networkId.caseInsensitiveCompare(coreId) == .orderedSame {
                    found = true
                    foundId = coreId
                }
            }
            
            if !found {
                let newGI = NSManagedObject(entity: entity, insertInto: context)
                let infoId = UUID(uuidString: gi.id)
                let infoCreatedAt = gi.createdAt
                let infoUpdatedAt = gi.updatedAt
                let infoLabel = gi.infoLabel
                let info = gi.information
                
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
                        // let nId = networkId
                        let cId = updateGI.id?.uuidString ?? ""
                        let cCreatedAt = updateGI.createdAt ?? ""
                        let cUpdatedAt = DateUtility.getFormattedDateAsString()
                        let cInfo = updateGI.information ?? ""
                        let cInfoLabel = updateGI.informationLabel ?? ""
                        
                        print("The updated at dates differ, let's make an update!")
                        
                        if coreUpdatedAt > networkUpdatedAt {
                            print("Core is more recent")
                            print("Let's send an update to the web app")
                            
                            // send network request to update web app
                            updateGeneralInformation(giId: cId, infoLabel: cInfoLabel, info: cInfo, createdAt: cCreatedAt, updatedAt: cUpdatedAt)
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
                        // print("No difference, no updates necessary")
                    }
                } catch {
                    print("Error updating general information = \(error)")
                }
            }
            
            found = false
            foundId = ""
        }
        
        // reload the data from core data
        loadItems()
        
        // Next, let's send any locally created
        // pieces of GI to the web app
        saveLocalData(giNetworkData: giNetworkDataArray)
    }
    
    private func saveLocalData(giNetworkData: [GeneralInformation]) {
        var matchFound: Bool = false
        
        giCoreArray.forEach { giCore in
            let coreId = giCore.id?.uuidString ?? ""
            let coreInfolabel = giCore.informationLabel ?? ""
            let coreInfo = giCore.information ?? ""
            let coreCreatedAt = giCore.createdAt ?? ""
            
            giNetworkData.forEach { giNetwork in
                let networkId = giNetwork.id
                
                if coreId.caseInsensitiveCompare(networkId) == .orderedSame {
                    matchFound = true
                }
            }
            
            if !matchFound {
                print("We found a case where a core data item was not in the network")
                print("Item ID: \(coreId)")
                print("Item Label: \(coreInfolabel)")
                
                // send any locally created items not already in the network data to the web app
                createGeneralInformation(id: coreId, infoLabel: coreInfolabel, info: coreInfo, createdAt: coreCreatedAt)
            }
            
            matchFound = false
        }
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new GIs to database = \(error)")
        }
    }
    
    private func createGeneralInformation(id: String, infoLabel: String, info: String, createdAt: String) {
        let giCreateService = GeneralInformationCreateService()
        
        progressHUD.show(onView: view, animated: true)
        giCreateService.createGeneralInformation(id: id, infoLabel: infoLabel, info: info, createdAt: createdAt, updatedAt: createdAt) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue creating GI data (GI POST request) - \(e)")
                return
            } else {
                print("SUCCESS - GI POST request")
            }
            self.progressHUD.hide(onView: self.view, animated: true)
        }
    }
    
    private func updateGeneralInformation(giId: String, infoLabel: String, info: String, createdAt: String, updatedAt: String) {
        let giEditService = GeneralInformationEditService()
        
        progressHUD.show(onView: view, animated: true)
        giEditService.updateGeneralInformation(id: giId, infoLabel: infoLabel, info: info, createdAt: createdAt, updatedAt: updatedAt) { [weak self] giData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue editing GI data (GI PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - GI PUT request")
            }
            self.progressHUD.hide(onView: self.view, animated: true)
        }
    }
}
