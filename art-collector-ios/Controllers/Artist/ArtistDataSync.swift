
//
//  ArtistDataSync.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

import UIKit
import CoreData

extension ArtistsViewController {
    func syncData() {
        let artistsService = ArtistsService()
        
        progressHUD.show(onView: view, animated: true)
        artistsService.getArtists { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting Artists data (Artists GET request) - \(e)")
                return
            } else {
                if let artistInfo = artistData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.saveNetworkData(artistsNetworkDataArray: artistInfo)
                } else {
                    self.progressHUD.hide(onView: self.view, animated: true)
                }
            }
        }
    }
    
    func saveNetworkData(artistsNetworkDataArray: [Artist]) {
            let entity = NSEntityDescription.entity(forEntityName: "ArtistCore", in: context)!
            
            // First, use the network response to create
            // or update any artists
            artistsNetworkDataArray.forEach { artist in
                var found = false
                var foundId: String = ""
                let networkId = artist.id

                artistsCoreArray.forEach { artistCore in
                    let coreId = artistCore.id?.uuidString ?? ""

                    if networkId.caseInsensitiveCompare(coreId) == .orderedSame {
                        found = true
                        foundId = coreId
                    }
                }

                if !found {
                    let newArtist = NSManagedObject(entity: entity, insertInto: context)
                    let artistId = UUID(uuidString: artist.id)
                    let artistCreatedAt = artist.createdAt
                    let artistUpdatedAt = artist.updatedAt
                    let artistFirstName = artist.firstName
                    let artistLastName = artist.lastName
                    let artistBiography = artist.biography
                    let artistAdditionalInfo = artist.additionalInfo
                    // TODO - Images
                    // let artistImage = artist.artistImage
                    
                    newArtist.setValue(artistId, forKey: "id")
                    newArtist.setValue(artistCreatedAt, forKey: "createdAt")
                    newArtist.setValue(artistUpdatedAt, forKey: "updatedAt")
                    newArtist.setValue(artistFirstName, forKey: "firstName")
                    newArtist.setValue(artistLastName, forKey: "lastName")
                    newArtist.setValue(artistBiography, forKey: "biography")
                    newArtist.setValue(artistAdditionalInfo, forKey: "additionalInfo")
                    // TODO - Images
                    // newArtist.setValue(artistUpdatedAt, forKey: "artistImage")

                    saveNewItem()
                } else {
                    let request: NSFetchRequest<ArtistCore> = ArtistCore.fetchRequest()
                    let uuid = UUID(uuidString: foundId)

                    request.predicate = NSPredicate(format: "id = %@", uuid! as NSUUID)
                    do {
                        let artistFromCore = try context.fetch(request)

                        let updateArtistManagedObject = artistFromCore[0] as NSManagedObject
                        let updateArtistData = artistFromCore[0] as ArtistCore

                        let networkUpdatedAt = artist.updatedAt
                        let coreUpdatedAt = updateArtistData.updatedAt ?? ""

                        if coreUpdatedAt != networkUpdatedAt {
    //                        let nId = networkId
                            let cId = updateArtistData.id?.uuidString ?? ""
                            let cCreatedAt = updateArtistData.createdAt ?? ""
                            let cUpdatedAt = DateUtility.getFormattedDateAsString()
                            let cFirstName = updateArtistData.firstName ?? ""
                            let cLastName = updateArtistData.lastName ?? ""
                            let cBiography = updateArtistData.biography ?? ""
                            let cAdditionalInfo = updateArtistData.additionalInfo ?? ""
//                            TODO - Images
//                            let cArtistImage = updateArtist.artistImage

                            print("The updated at dates differ, let's make an update!")

                            if coreUpdatedAt > networkUpdatedAt {
                                print("Core is more recent")
                                print("Let's send an update to the web app")

                                // send network request to update web app
                                updateArtist(artistId: cId, fName: cFirstName, lName: cLastName, addInfo: cAdditionalInfo, bio: cBiography, createdAt: cCreatedAt, updatedAt: cUpdatedAt)
                            } else {
                                print("Network is more recent")
                                print("Let's update local database")

                                // update core with latest artist
                                let networkFirstName = artist.firstName
                                let networkLastName = artist.lastName
                                let networkBiography = artist.biography
                                let networkAdditionalInfo = artist.additionalInfo

                                updateArtistManagedObject.setValue(networkUpdatedAt, forKey: "updatedAt")
                                updateArtistManagedObject.setValue(networkFirstName, forKey: "firstName")
                                updateArtistManagedObject.setValue(networkLastName, forKey: "lastName")
                                updateArtistManagedObject.setValue(networkBiography, forKey: "biography")
                                updateArtistManagedObject.setValue(networkAdditionalInfo, forKey: "additionalInfo")
                                // TODO - Images
                                // updateArtistManagedObject.setValue(artistUpdatedAt, forKey: "artistImage")

                                saveNewItem()
                            }
                        } else {
                             print("No difference, no updates necessary")
                        }
                    } catch {
                        print("Error updating artist information = \(error)")
                    }
                }

                found = false
                foundId = ""
            }

            // reload the data from core data
            loadItems()

            // Next, let's send any locally created
            // pieces of GI to the web app
            saveLocalData(artistsNetworkData: artistsNetworkDataArray)
    }
        
        
    private func saveLocalData(artistsNetworkData: [Artist]) {
        var matchFound: Bool = false
        
        artistsCoreArray.forEach { artistCore in
            let coreId = artistCore.id?.uuidString ?? ""
            let coreCreatedAt = artistCore.createdAt ?? ""
            let coreFirstName = artistCore.firstName ?? ""
            let coreLastName = artistCore.lastName ?? ""
            let coreBiography = artistCore.biography ?? ""
            let coreAdditionalInfo = artistCore.additionalInfo ?? ""

            artistsNetworkData.forEach { artistNetwork in
                let networkId = artistNetwork.id

                if coreId.caseInsensitiveCompare(networkId) == .orderedSame {
                    matchFound = true
                }
            }

            if !matchFound {
                print("We found a case where a core data item was not in the network")
                print("Item ID: \(coreId)")
                print("Item First Name: \(coreFirstName)")
                print("Item Last Name: \(coreLastName)")
                print("Item Biography: \(coreBiography)")
                print("Item Additional Info: \(coreAdditionalInfo)")

                // send any locally created items not already in the network data to the web app
                createArtist(id: coreId, fName: coreFirstName, lName: coreLastName, addInfo: coreAdditionalInfo, bio: coreBiography, createdAt: coreCreatedAt)
            }

            matchFound = false
        }
    }
        
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new artists to database = \(error)")
        }
    }
    
    private func createArtist(id: String, fName: String, lName: String, addInfo: String, bio: String, createdAt: String) {
        let artistCreateService = ArtistCreateService()

        progressHUD.show(onView: view, animated: true)
        artistCreateService.createArtist(id: id, fName: fName, lName: lName, bio: bio, additionalInfo: addInfo, image: "", createdAt: createdAt, updatedAt: createdAt) { [weak self] artistData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue posting artist data (Artists POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Artists POST request")
            }
            self.progressHUD.hide(onView: self.view, animated: true)
        }
    }
    
    private func updateArtist(artistId: String, fName: String, lName: String, addInfo: String, bio: String, createdAt: String, updatedAt: String) {
        let artistEditService = ArtistEditService()

        progressHUD.show(onView: view, animated: true)
        artistEditService.updateArtist(id: artistId, fName: fName, lName: lName, bio: bio, additionalInfo: addInfo, image: "", createdAt: createdAt, updatedAt: updatedAt) { [weak self] artistData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue creating artist data (GI PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - artist PUT request")
            }
            self.progressHUD.hide(onView: self.view, animated: true)
        }
    }
}
