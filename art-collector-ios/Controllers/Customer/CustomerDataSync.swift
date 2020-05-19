//
//  CustomerDataSync.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

extension CustomersViewController {
    func syncData() {
        let customersService = CustomersService()

        progressHUD.show(onView: view, animated: true)
        customersService.getCustomers { [weak self] customerData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue getting customer data (customer GET request) - \(e)")
                return
            } else {
                if let customers = customerData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.saveCustomerData(customerNetworkDataArray: customers)
                } else {
                    self.progressHUD.hide(onView: self.view, animated: true)
                }
            }
        }
    }
    
    func saveCustomerData(customerNetworkDataArray: [Customer]) {
        let customerEntity = NSEntityDescription.entity(forEntityName: "CustomerCore", in: context)!

        // First, use the network response create
        // or update any pieces of GI
        customerNetworkDataArray.forEach { customer in
            var found = false
            var foundId: String = ""
            let networkId = customer.id

            customersCoreArray.forEach { customerCore in
                let coreId = customerCore.id?.uuidString ?? ""

                if networkId.caseInsensitiveCompare(coreId) == .orderedSame {
                    found = true
                    foundId = coreId
                }
            }

            if !found {
                let newCustomer = NSManagedObject(entity: customerEntity, insertInto: context)
                let customerId = UUID(uuidString: customer.id)
                let customerCreatedAt = customer.createdAt
                let customerUpdatedAt = customer.updatedAt
                let customerFirstName = customer.firstName
                let customerLastName = customer.lastName
                let customerCity = customer.city
                let customerState = customer.state
                let customerZip = customer.zip
                let customerAddress = customer.address
                let customerPhone = customer.phone
                let customerEmail = customer.email
                let customerCollections = customer.collections ?? []
                
                newCustomer.setValue(customerId, forKey: "id")
                newCustomer.setValue(customerCreatedAt, forKey: "createdAt")
                newCustomer.setValue(customerUpdatedAt, forKey: "updatedAt")
                newCustomer.setValue(customerFirstName, forKey: "firstName")
                newCustomer.setValue(customerLastName, forKey: "lastName")
                newCustomer.setValue(customerCity, forKey: "city")
                newCustomer.setValue(customerState, forKey: "state")
                newCustomer.setValue(customerZip, forKey: "zip")
                newCustomer.setValue(customerAddress, forKey: "streetAddress")
                newCustomer.setValue(customerPhone, forKey: "phoneNumber")
                newCustomer.setValue(customerEmail, forKey: "emailAddress")

                saveNewItem()
                
                let custId = customerId ?? UUID()
                saveCollectionData(collections: customerCollections, customerId: custId)
            } else {
                let request: NSFetchRequest<CustomerCore> = CustomerCore.fetchRequest()
                let uuid = UUID(uuidString: foundId)

                request.predicate = NSPredicate(format: "id = %@", uuid! as NSUUID)
                do {
                    let customerFromCore = try context.fetch(request)

                    let updateCustomerManagedObject = customerFromCore[0] as NSManagedObject
                    let updateCustomerData = customerFromCore[0] as CustomerCore

                    let networkUpdatedAt = customer.updatedAt
                    let coreUpdatedAt = updateCustomerData.updatedAt ?? ""

                    if coreUpdatedAt != networkUpdatedAt {
                        // let nId = networkId
                        let cId = updateCustomerData.id?.uuidString ?? ""
                        let cCreatedAt = updateCustomerData.createdAt ?? ""
                        let cUpdatedAt = DateUtility.getFormattedDateAsString()
                        let cCustomerFirstName = updateCustomerData.firstName ?? ""
                        let cCustomerLastName = updateCustomerData.lastName ?? ""
                        let cCustomerCity = updateCustomerData.city ?? ""
                        let cCustomerState = updateCustomerData.state ?? ""
                        let cCustomerZip = updateCustomerData.zip ?? ""
                        let cCustomerAddress = updateCustomerData.streetAddress ?? ""
                        let cCustomerPhone = updateCustomerData.phoneNumber ?? ""
                        let cCustomerEmail = updateCustomerData.emailAddress ?? ""

                        if coreUpdatedAt > networkUpdatedAt {
                            // send network request to update web app
                            updateCustomer(id: cId, fName: cCustomerFirstName, lName: cCustomerLastName, email: cCustomerEmail, phone: cCustomerPhone, street: cCustomerAddress, city: cCustomerCity, state: cCustomerState, zip: cCustomerZip, referred: "", notes: "", createdAt: cCreatedAt, updatedAt: cUpdatedAt)
                        } else {
                            // update core with latest customer
                            let networkFirstName = customer.firstName
                            let networkLastName = customer.lastName
                            let networkEmail = customer.email ?? ""
                            let networkPhone = customer.phone ?? ""
                            let networkStreet = customer.address ?? ""
                            let networkCity = customer.city ?? ""
                            let networkZip = customer.zip ?? ""
//                            let networkReferredBy = customer.referrredBy ?? ""
//                            let networkNotes = customer.projectNotes ?? ""

                            updateCustomerManagedObject.setValue(networkUpdatedAt, forKey: "updatedAt")
                            updateCustomerManagedObject.setValue(networkFirstName, forKey: "firstName")
                            updateCustomerManagedObject.setValue(networkLastName, forKey: "lastName")
                            updateCustomerManagedObject.setValue(networkEmail, forKey: "emailAddress")
                            updateCustomerManagedObject.setValue(networkPhone, forKey: "phoneNumber")
                            updateCustomerManagedObject.setValue(networkStreet, forKey: "streetAddress")
                            updateCustomerManagedObject.setValue(networkCity, forKey: "city")
                            updateCustomerManagedObject.setValue(networkZip, forKey: "state")
                            
                            saveNewItem()
                        }
                        
                        // check to see if any of the customer's collections have been updated
                        // save locally if they have
                    } else {
//                        print("No difference for the customer, no updates necessary")
                    }
                } catch {
                    print("Error updating customer = \(error)")
                }
                
                updateLocalCollections(customerId: uuid!)
            }
        
            found = false
            foundId = ""
        }
        
        // reload the data from core data
        loadItems()

        // Next, let's send any locally created
        // pieces of GI to the web app
        saveLocalData(customerNetworkData: customerNetworkDataArray)
    }
    
    private func updateLocalCollections(customerId: UUID) {
        let request: NSFetchRequest<CollectionCore> = CollectionCore.fetchRequest()
        request.predicate = NSPredicate(format: "customerId = %@", customerId as NSUUID)
        
        var collectionsFromCore: [CollectionCore]? = []
        do {
            collectionsFromCore = try context.fetch(request)
        } catch {
            print("Error getting collection from core - \(error)")
        }

        collectionsFromCore?.forEach{ collection in
            if let id = collection.id,
                let updatedAt = collection.updatedAt,
                let customerId = collection.customerId {
                self.getCollectionInfoForUpdate(collectionCore: collection, collectionId: id.uuidString, custId: customerId, updatedAt: updatedAt)
            }
        }
    }
    
    private func getCollectionInfoForUpdate(collectionCore: CollectionCore, collectionId: String, custId: UUID, updatedAt: String) {
        let getCollectionService = GetCollectionService()
        
        progressHUD.show(onView: view, animated: true)
        getCollectionService.getCollectionInfo(collectionId: collectionId) { [weak self] collectionData, error in
            guard let self = self else {
                return
            }
            
            defer {
                self.progressHUD.hide(onView: self.view, animated: true)
            }
            
            if let e = error {
                print("Issue getting collection info data (Collection GET request) - \(e)")
                return
            } else {
                if let collection = collectionData {
                    let name = collection.collectionName ?? ""
                    let identifier = collection.identifier ?? ""
                    let year = collection.year ?? ""
                    let id = UUID(uuidString: collectionId)!
                    let customerId = custId
                    let networkUpdatedAt = collection.updatedAt
                    
                    if networkUpdatedAt == updatedAt {
//                        print("No difference found, no update necessary for collection: \(id)")
//                        print("Let's check all of the artwork in the collection")
                        
                        self.updateArtwork(collectionId: id, networkArtworkCollectionData: collection.artworks!)
                    } else {
//                        print("Network updated at: \(networkUpdatedAt)")
//                        print("Local updated at: \(updatedAt)")
                        if networkUpdatedAt > updatedAt {
//                            print("Newer version found from network, updated locally - \(id)")
                            self.updateCollectionInCore(id: id, collectionName: name, identifier: identifier, year: year, custId: customerId, updatedAt: networkUpdatedAt)
                        } else {
//                            print("Newer version found locally, updating the network - \(id)")
                            let collName = collectionCore.collectionName ?? ""
                            let collIdentifier = collectionCore.identifier ?? ""
                            let collYear = collectionCore.year ?? ""
                            
                            self.updateNetworkCollection(id: id, collectionName: collName, identifier: collIdentifier, year: collYear, custId: custId, updatedAt: updatedAt)
                        }
                    }
                }
            }
        }
    }
    
    private func updateArtwork(collectionId: UUID, networkArtworkCollectionData: [Artwork]) {
        let request: NSFetchRequest<ArtworkCore> = ArtworkCore.fetchRequest()
        request.predicate = NSPredicate(format: "collectionId = %@", collectionId  as NSUUID)

        var artworksFromCore: [ArtworkCore]? = []
        do {
           artworksFromCore = try context.fetch(request)
        } catch {
           print("Error getting artwork from core - \(error)")
        }
        
        artworksFromCore?.forEach { artworkCore in
            guard let artworkCoreId = artworkCore.id else { return }
            guard let artworkCoreCustomerId = artworkCore.customerId else { return }
            guard let artworkCoreCollectionId = artworkCore.collectionId else { return }
            
            let coreStringId = artworkCore.id?.uuidString ?? ""
            let artworkCoreUpdatedAt = artworkCore.updatedAt ?? ""
            let artworkCoreCreatedAt = artworkCore.createdAt ?? ""
            let artworkCoreObjectId = artworkCore.objectId ?? ""
            let artworkCoreTitle = artworkCore.title ?? ""
            let artworkCoreType = artworkCore.artType ?? ""
            let artworkCoreDate = artworkCore.date ?? ""
            let artworkCoreMedium = artworkCore.medium ?? ""
            let artworkCoreDescription = artworkCore.artDescription ?? ""
            let artworkCoreDimensions = artworkCore.dimensions ?? ""
            let artworkCoreFrameDimensions = artworkCore.frameDimensions ?? ""
            let artworkCoreCondition = artworkCore.condition ?? ""
            let artworkCoreCurrentLocation = artworkCore.currentLocation ?? ""
            let artworkCoreSource = artworkCore.source ?? ""
            let artworkCoreDateAcquired = artworkCore.dateAcquired ?? ""
            let artworkCoreAmountPaid = artworkCore.amountPaid ?? ""
            let artworkCoreCurrentValue = artworkCore.currentValue ?? ""
            let artworkCoreNotes = artworkCore.notes ?? ""
            let artworkCoreAdditionalInfoLabel = artworkCore.additionalInfoLabel ?? ""
            let artworkCoreAdditionalInfoText = artworkCore.additionalInfoText ?? ""
            let artworkCoreReviewedBy = artworkCore.reviewedBy ?? ""
            let artworkCoreReviewedDate = artworkCore.reviewedDate ?? ""
            let artworkCoreProvenance = artworkCore.provenance ?? ""
            let artworkCoreDateAcquiredLabel = artworkCore.dateAcquiredLabel ?? ""
            let artworkCoreShowGeneralInfo = artworkCore.showGeneralInfo
            let artworkCoreCustomTitle = artworkCore.customTitle ?? ""
            
            // images
            let artworkCoreImage = artworkCore.image ?? ""
            let artworkCoreNotesImage = artworkCore.notesImage ?? ""
            let artworkCoreNotesImageTwo = artworkCore.notesImageTwo ?? ""
            let artworkCoreAdditionalInfoImage = artworkCore.additionalInfoImage ?? ""
            let artworkCoreAdditionalInfoImageTwo = artworkCore.additionalInfoImageTwo ?? ""
            
            // artist and general info arrays
//            let artworkCoreArtistIds = artworkCore.artistIds ?? []
//            let artworkCoreGeneralInfoIds = artworkCore.generalInfoIds ?? []
            
            var matchFound: Bool = false
            networkArtworkCollectionData.forEach { artworkNetwork in
                let artworkNetworkId = artworkNetwork.id
                let artworkNetworkUpdatedAt = artworkNetwork.updatedAt
                let artworkNetworkCustomerId = artworkNetwork.customerId ?? ""
                let artworkNetworkCollectionId = artworkNetwork.collectionId ?? ""
                let artworkNetworkObjectId = artworkNetwork.objectId ?? ""
                let artworkNetworkTitle = artworkNetwork.title ?? ""
                let artworkNetworkType = artworkNetwork.artType ?? ""
                let artworkNetworkDate = artworkNetwork.date ?? ""
                let artworkNetworkMedium = artworkNetwork.medium ?? ""
                let artworkNetworkDescription = artworkNetwork.description ?? ""
                let artworkNetworkDimensions = artworkNetwork.dimensions ?? ""
                let artworkNetworkFrameDimensions = artworkNetwork.frameDimensions ?? ""
                let artworkNetworkCondition = artworkNetwork.condition ?? ""
                let artworkNetworkCurrentLocation = artworkNetwork.currentLocation ?? ""
                let artworkNetworkSource = artworkNetwork.source ?? ""
                let artworkNetworkDateAcquired = artworkNetwork.dateAcquired ?? ""
                let artworkNetworkAmountPaid = artworkNetwork.amountPaid ?? ""
                let artworkNetworkCurrentValue = artworkNetwork.currentValue ?? ""
                let artworkNetworkNotes = artworkNetwork.notes ?? ""
                let artworkNetworkAdditionalInfoLabel = artworkNetwork.additionalInfoLabel ?? ""
                let artworkNetworkAdditionalInfoText = artworkNetwork.additionalInfoText ?? ""
                let artworkNetworkReviewedBy = artworkNetwork.reviewedBy ?? ""
                let artworkNetworkReviewedDate = artworkNetwork.reviewedDate ?? ""
                let artworkNetworkProvenance = artworkNetwork.provenance ?? ""
                let artworkNetworkDateAcquiredLabel = artworkNetwork.dateAcquiredLabel ?? ""
                let artworkNetworkShowGeneralInfo = artworkNetwork.showGeneralInfo ?? false
                let artworkNetworkCustomTitle = artworkNetwork.customTitle ?? ""
                
                // images
                let artworkNetworkImage = artworkNetwork.image?.thumb?.url ?? ""
                let artworkNetworkNotesImage = artworkNetwork.notesImage?.thumb?.url ?? ""
                let artworkNetworkNotesImageTwo = artworkNetwork.notesImageTwo?.thumb?.url ?? ""
                let artworkNetworkAdditionalInfoImage = artworkNetwork.additionalInfoImage?.thumb?.url ?? ""
                let artworkNetworkAdditionalInfoImageTwo = artworkNetwork.additionalInfoImageTwo?.thumb?.url ?? ""
                
                // artist and general info arrays
    //            let artworkNetworkArtistIds = artworkNetwork.artistIds ?? []
    //            let artworkNetworkGeneralInfoIds = artworkNetwork.generalInfoIds ?? []
                
                if coreStringId.caseInsensitiveCompare(artworkNetworkId) == .orderedSame {
                    matchFound = true
                    
                    if artworkCoreUpdatedAt == artworkNetworkUpdatedAt {
//                        print("No updates needed to this piece of art")
                    } else {
                        if artworkCoreUpdatedAt > artworkNetworkUpdatedAt {
                            // print("Found a local artwork that needs to be updated in web - \(artworkCore.title ?? "")")
                            updateArtworkInWeb(id: artworkCoreId, objectId: artworkCoreObjectId, artType: artworkCoreType, title: artworkCoreTitle, date: artworkCoreDate, medium: artworkCoreMedium, description: artworkCoreDescription, mainImage: artworkCoreImage, dimensions: artworkCoreDimensions, frameDimensions: artworkCoreFrameDimensions, condition: artworkCoreCondition, currentLocation: artworkCoreCurrentLocation, source: artworkCoreSource, dateAcquiredLabel: artworkCoreDateAcquiredLabel, dateAcquired: artworkCoreDateAcquired, amountPaid: artworkCoreAmountPaid, currentValue: artworkCoreCurrentValue, notes: artworkCoreNotes, notesImage: artworkCoreNotesImage, notesImageTwo: artworkCoreNotesImageTwo, additionalInfoLabel: artworkCoreAdditionalInfoLabel, additionalInfoText: artworkCoreAdditionalInfoText, additionalInfoImage: artworkCoreAdditionalInfoImage, additionalInfoImageTwo: artworkCoreAdditionalInfoImageTwo, reviewedBy: artworkCoreReviewedBy, reviewedDate: artworkCoreReviewedDate, provenance: artworkCoreProvenance, customTitle: artworkCoreCustomTitle, customerId: artworkCoreCustomerId, collectionId: artworkCoreCollectionId, showGeneralInfo: artworkCoreShowGeneralInfo, createdAt: artworkCoreCreatedAt, updatedAt: artworkCoreUpdatedAt)
                            
                        } else {
                            // print("Found a network artwork that needs to be updated in core - \(artworkNetwork.title ?? "")")
                            updateArtInCore(id: artworkNetworkId, objectId: artworkNetworkObjectId, title: artworkNetworkTitle, artType: artworkNetworkType, date: artworkNetworkDate, medium: artworkNetworkMedium, image: artworkNetworkImage, description: artworkNetworkDescription, dimensions: artworkNetworkDimensions, frameDimensions: artworkNetworkFrameDimensions, condition: artworkNetworkCondition, currentLocation: artworkNetworkCurrentLocation, source: artworkNetworkSource, dateAcquired: artworkNetworkDateAcquired, amountPaid: artworkNetworkAmountPaid, currentValue: artworkNetworkCurrentValue, notes: artworkNetworkNotes, notesImage: artworkNetworkNotesImage, additionalInfoLabel: artworkNetworkAdditionalInfoLabel, additionalInfoText: artworkNetworkAdditionalInfoText, additionalInfoImage: artworkNetworkAdditionalInfoImage, additionalPdf: "", reviewedBy: artworkNetworkReviewedBy, reviewedDate: artworkNetworkReviewedDate, provenance: artworkNetworkProvenance, dateAcquiredLabel: artworkNetworkDateAcquiredLabel, collId: artworkNetworkCollectionId, custId: artworkNetworkCustomerId, notesImageTwo: artworkNetworkNotesImageTwo, additionalInfoImageTwo: artworkNetworkAdditionalInfoImageTwo, showGeneralInfo: artworkNetworkShowGeneralInfo, customTitle: artworkNetworkCustomTitle, updatedAt: artworkNetworkUpdatedAt)
                            
                        }
                    }
                }
            }
            
            if !matchFound {
                createArtworkInWeb(id: artworkCoreId, objectId: artworkCoreObjectId, artType: artworkCoreType, title: artworkCoreTitle, date: artworkCoreDate, medium: artworkCoreMedium, description: artworkCoreDescription, mainImage: artworkCoreImage, dimensions: artworkCoreDimensions, frameDimensions: artworkCoreFrameDimensions, condition: artworkCoreCondition, currentLocation: artworkCoreCurrentLocation, source: artworkCoreSource, dateAcquiredLabel: artworkCoreDateAcquiredLabel, dateAcquired: artworkCoreDateAcquired, amountPaid: artworkCoreAmountPaid, currentValue: artworkCoreCurrentValue, notes: artworkCoreNotes, notesImage: artworkCoreNotesImage, notesImageTwo: artworkCoreNotesImageTwo, additionalInfoLabel: artworkCoreAdditionalInfoLabel, additionalInfoText: artworkCoreAdditionalInfoText, additionalInfoImage: artworkCoreAdditionalInfoImage, additionalInfoImageTwo: artworkCoreAdditionalInfoImageTwo, reviewedBy: artworkCoreReviewedBy, reviewedDate: artworkCoreReviewedDate, provenance: artworkCoreProvenance, customTitle: artworkCoreCustomTitle, customerId: artworkCoreCustomerId, collectionId: artworkCoreCollectionId, showGeneralInfo: artworkCoreShowGeneralInfo, createdAt: artworkCoreCreatedAt, updatedAt: artworkCoreUpdatedAt)
            }
        }
    }
    
    private func updateNetworkCollection(id: UUID, collectionName: String, identifier: String, year: String, custId: UUID, updatedAt: String) {
        let updateCollection = CollectionEditService()
        
        updateCollection.updateCollection(id: id.uuidString, name: collectionName, year: year, identifier: identifier, customerId: custId.uuidString, updatedAt: updatedAt) { collectionData, error in
            if let e = error {
                print("Issue updating collection info data (Collection POST request) - \(e)")
                return
            } else {
                print("Updated collection \(id) successfully")
            }
        }
    }
    
    private func updateCollectionInCore(id: UUID, collectionName: String, identifier: String, year: String, custId: UUID, updatedAt: String) {
        let request: NSFetchRequest<CollectionCore> = CollectionCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        do {
            let collection = try context.fetch(request)

            let updateCollection = collection[0] as NSManagedObject
            updateCollection.setValue(updatedAt, forKey: "updatedAt")
            updateCollection.setValue(collectionName, forKey: "collectionName")
            updateCollection.setValue(year, forKey: "year")
            updateCollection.setValue(identifier, forKey: "identifier")
            updateCollection.setValue(custId, forKey: "customerId")

        } catch {
            print("Error updating collection information = \(error)")
        }

        saveNewItem()
    }
    
    private func saveLocalData(customerNetworkData: [Customer]) {
        var matchFound: Bool = false

        customersCoreArray.forEach { customerCore in
            let coreId = customerCore.id?.uuidString ?? ""
            let coreCreatedAt = customerCore.createdAt ?? ""
            let coreFirstName = customerCore.firstName ?? ""
            let coreLastName = customerCore.lastName ?? ""
            let coreEmail = customerCore.emailAddress ?? ""
            let corePhone = customerCore.phoneNumber ?? ""
            let coreStreet = customerCore.streetAddress ?? ""
            let coreCity = customerCore.city ?? ""
            let coreZip = customerCore.zip ?? ""
            let coreReferredBy = customerCore.referredBy ?? ""
            let coreNotes = customerCore.projectNotes ?? ""

            customerNetworkData.forEach { customerNetwork in
                let networkId = customerNetwork.id

                if coreId.caseInsensitiveCompare(networkId) == .orderedSame {
                    matchFound = true
                }
            }

            if !matchFound {
                print("We found a case where a core data item was not in the network")
                print("Item ID: \(coreId)")

                // send any locally created items not already in the network data to the web app
                createCustomer(id: coreId, fName: coreFirstName, lName: coreLastName, email: coreEmail, phone: corePhone, street: coreStreet, city: coreCity, zip: coreZip, referred: coreReferredBy, notes: coreNotes, createdAt: coreCreatedAt)
            }

            matchFound = false
        }
        
        saveLocalCollectionsToNetwork()
    }
    
    private func saveLocalCollectionsToNetwork() {
        customersCoreArray.forEach { customer in
            guard let customerId = customer.id else { return }
            
            let request: NSFetchRequest<CollectionCore> = CollectionCore.fetchRequest()
            request.predicate = NSPredicate(format: "customerId = %@", customerId as NSUUID)
            
            do {
                let collectionsFromCore = try context.fetch(request)
                
                checkAndUpdateNetworkCollections(customerId: customerId, customerCollections: collectionsFromCore)
            } catch {
                print("Error getting collection from core - \(error)")
            }
        }
    }
    
    private func checkAndUpdateNetworkCollections(customerId: UUID, customerCollections: [CollectionCore]) {
        let getCustomerService = GetCustomerService()
        
        getCustomerService.getCustomer(customerId: customerId.uuidString) { customerData, error in
            if let e = error {
                print("Issue getting customer data (customer GET request) - \(e)")
                return
            } else {
                if let customer = customerData {
                    self.updateNetworkCustomer(customer: customer, customerCoreCollections: customerCollections)
                }
            }
        }
    }
    
    private func updateNetworkCustomer(customer: Customer, customerCoreCollections: [CollectionCore]) {
        let networkCustomerCollections = customer.collections
        
        customerCoreCollections.forEach { coreCollection in
            guard let collectionId = coreCollection.id?.uuidString else { return }
            
            var match = false
            networkCustomerCollections?.forEach { networkCollection in
                if collectionId.caseInsensitiveCompare(networkCollection.id) == .orderedSame {
                    match = true
                }
            }
            
            if !match {
//                print("Found a local collection that doesn't exist in the network: \(collectionId)")
                if let id = coreCollection.id,
                    let customerId = coreCollection.customerId {
                    let name = coreCollection.collectionName ?? ""
                    let year = coreCollection.year ?? ""
                    let identifier = coreCollection.identifier ?? ""
                    let createdAt = coreCollection.createdAt ?? ""
                    let updatedAt = coreCollection.updatedAt ?? ""
                    
                    sendNewCollection(id: id, collectionName: name, collectionYear: year, collectionIdentifier: identifier, customerId: customerId, createdAt: createdAt, updatedAt: updatedAt)
                }
            }
            
            match = false
        }
    }
    
    
    private func sendNewCollection(id: UUID, collectionName: String, collectionYear: String, collectionIdentifier: String, customerId: UUID, createdAt: String, updatedAt: String) {
        let collectionId = id.uuidString
        let collectionCustomerId = customerId.uuidString
        
        let collectionCreateService = CollectionCreateService()
        
        collectionCreateService.createCollection(id: collectionId, name: collectionName, year: collectionYear, identifier: collectionIdentifier, customerId: collectionCustomerId, createdAt: createdAt, updatedAt: updatedAt) { collectionData, error in
            
            if let e = error {
                print("Error when sending new collection to the web - \(e)")
            } else {
                print("Sent the new collection to the web!")
            }
        }
    }
    
    private func saveCollectionData(collections: [Collection], customerId: UUID) {
        collections.forEach { (collection) in
            let id = collection.id
            getCollectionInfo(collectionId: id, custId: customerId)
        }
    }
    
    private func saveCollectionToCore(id: UUID, collectionName: String, identifier: String, year: String, custId: UUID, createdAt: String, updatedAt: String, artwork: [Artwork]) {
        let collectionEntity = NSEntityDescription.entity(forEntityName: "CollectionCore", in: context)!
        let newCollection = NSManagedObject(entity: collectionEntity, insertInto: context)
        let customerId = custId
        
        newCollection.setValue(id, forKey: "id")
        newCollection.setValue(createdAt, forKey: "createdAt")
        newCollection.setValue(updatedAt, forKey: "updatedAt")
        newCollection.setValue(collectionName, forKey: "collectionName")
        newCollection.setValue(identifier, forKey: "identifier")
        newCollection.setValue(year, forKey: "year")
        newCollection.setValue(customerId, forKey: "customerId")
        
        saveNewItem()
        
        artwork.forEach { (art) in
            let id = art.id
            let objectId = art.objectId ?? ""
            let title = art.title ?? ""
            let artType = art.artType ?? ""
            let date = art.date ?? ""
            let medium = art.medium ?? ""
            let description = art.description ?? ""
            let dimensions = art.dimensions ?? ""
            let frameDimensions = art.frameDimensions ?? ""
            let condition = art.condition ?? ""
            let currentLocation = art.currentLocation ?? ""
            let source = art.source ?? ""
            let dateAcquired = art.dateAcquired ?? ""
            let amountPaid = art.amountPaid ?? ""
            let currentValue = art.currentValue ?? ""
            let notes = art.notes ?? ""
            let additionalInfoLabel = art.additionalInfoLabel ?? ""
            let additionalInfoText = art.additionalInfoText ?? ""
            let reviewedBy = art.reviewedBy ?? ""
            let reviewedDate = art.reviewedDate ?? ""
            let provenance = art.provenance ?? ""
            let dateAcquiredLabel = art.dateAcquiredLabel ?? ""
            let collectionId = art.collectionId ?? ""
            let customerId = art.customerId ?? ""
            let showGeneralInfo = art.showGeneralInfo ?? false
            let customTitle = art.customTitle ?? ""
            let createdAt = art.createdAt
            let updatedAt = art.updatedAt
            
            // images
            let image = art.image?.thumb?.url ?? ""
            let notesImage = art.notesImage?.thumb?.url ?? ""
            let notesImageTwo = art.notesImageTwo?.thumb?.url ?? ""
            let additionalInfoImage = art.additionalInfoImage?.thumb?.url ?? ""
            let additionalInfoImageTwo = art.additionalInfoImageTwo?.thumb?.url ?? ""
            
            // artist and gi arrays
            let artistIds = art.artistIds ?? []
            let generalInfoIds = art.generalInfoIds ?? []
            
            saveArtToCore(id: id, objectId: objectId, title: title, artType: artType, date: date, medium: medium, image: image, description: description, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalPdf: "", reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, dateAcquiredLabel: dateAcquiredLabel, collId: collectionId, custId: customerId, notesImageTwo: notesImageTwo, additionalInfoImageTwo: additionalInfoImageTwo, showGeneralInfo: showGeneralInfo, customTitle: customTitle, createdAt: createdAt, updatedAt: updatedAt, artistIds: artistIds, generalInfoIds: generalInfoIds)
        }
    }

    private func saveArtToCore(id: String, objectId: String, title: String, artType: String, date: String, medium: String, image: String, description: String, dimensions: String, frameDimensions: String, condition: String, currentLocation: String, source: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalPdf: String, reviewedBy: String, reviewedDate: String, provenance: String, dateAcquiredLabel: String, collId: String, custId: String, notesImageTwo: String, additionalInfoImageTwo: String, showGeneralInfo: Bool, customTitle: String, createdAt: String, updatedAt: String, artistIds: [String], generalInfoIds: [String]) {
        let artworkEntity = NSEntityDescription.entity(forEntityName: "ArtworkCore", in: context)!
        let newArtwork = NSManagedObject(entity: artworkEntity, insertInto: context)
        
        let artworkId = UUID(uuidString: id)
        let collectionId = UUID(uuidString: collId)
        let customerId = UUID(uuidString: custId)
        
        newArtwork.setValue(artworkId, forKey: "id")
        newArtwork.setValue(createdAt, forKey: "createdAt")
        newArtwork.setValue(updatedAt, forKey: "updatedAt")
        newArtwork.setValue(customerId, forKey: "customerId")
        newArtwork.setValue(collectionId, forKey: "collectionId")
        newArtwork.setValue(objectId, forKey: "objectId")
        newArtwork.setValue(title, forKey: "title")
        newArtwork.setValue(artType, forKey: "artType")
        newArtwork.setValue(date, forKey: "date")
        newArtwork.setValue(medium, forKey: "medium")
        newArtwork.setValue(description, forKey: "artDescription")
        newArtwork.setValue(dimensions, forKey: "dimensions")
        newArtwork.setValue(frameDimensions, forKey: "frameDimensions")
        newArtwork.setValue(condition, forKey: "condition")
        newArtwork.setValue(currentLocation, forKey: "currentLocation")
        newArtwork.setValue(source, forKey: "source")
        newArtwork.setValue(dateAcquired, forKey: "dateAcquired")
        newArtwork.setValue(amountPaid, forKey: "amountPaid")
        newArtwork.setValue(notes, forKey: "notes")
        newArtwork.setValue(additionalInfoLabel, forKey: "additionalInfoLabel")
        newArtwork.setValue(additionalInfoText, forKey: "additionalInfoText")
        newArtwork.setValue(reviewedBy, forKey: "reviewedBy")
        newArtwork.setValue(reviewedDate, forKey: "reviewedDate")
        newArtwork.setValue(provenance, forKey: "provenance")
        newArtwork.setValue(dateAcquiredLabel, forKey: "dateAcquiredLabel")
        newArtwork.setValue(showGeneralInfo, forKey: "showGeneralInfo")
        newArtwork.setValue(customTitle, forKey: "customTitle")
        
        // artist and GI arrays
        newArtwork.setValue(artistIds, forKey: "artistIds")
        newArtwork.setValue(generalInfoIds, forKey: "generalInfoIds")
        
        // images
        let mainImageNetwork = downloadImage(url: image)
        let notesImageNetwork = downloadImage(url: notesImage)
        let notesImageTwoNetwork = downloadImage(url: notesImageTwo)
        let additionalInfoImageNetwork = downloadImage(url: additionalInfoImage)
        let additionalInfoImageTwoNetwork = downloadImage(url: additionalInfoImageTwo)
        
        newArtwork.setValue(mainImageNetwork, forKey: "image")
        newArtwork.setValue(notesImageNetwork, forKey: "notesImage")
        newArtwork.setValue(notesImageTwoNetwork, forKey: "notesImageTwo")
        newArtwork.setValue(additionalInfoImageNetwork, forKey: "additionalInfoImage")
        newArtwork.setValue(additionalInfoImageTwoNetwork, forKey: "additionalInfoImageTwo")
        
        saveNewItem()
    }
    
    private func updateArtInCore(id: String, objectId: String, title: String, artType: String, date: String, medium: String, image: String, description: String, dimensions: String, frameDimensions: String, condition: String, currentLocation: String, source: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalPdf: String, reviewedBy: String, reviewedDate: String, provenance: String, dateAcquiredLabel: String, collId: String, custId: String, notesImageTwo: String, additionalInfoImageTwo: String, showGeneralInfo: Bool, customTitle: String, updatedAt: String) {
        
        let artworkId = UUID(uuidString: id)
        let collectionId = UUID(uuidString: collId)
        let customerId = UUID(uuidString: custId)
        
        let request: NSFetchRequest<ArtworkCore> = ArtworkCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artworkId! as NSUUID)
          
        do {
            let artwork = try context.fetch(request)

            let updateArtwork = artwork[0] as NSManagedObject
            updateArtwork.setValue(artworkId    , forKey: "id")
//            updateArtwork.setValue(createdAt, forKey: "createdAt")
            updateArtwork.setValue(updatedAt, forKey: "updatedAt")
            updateArtwork.setValue(customerId, forKey: "customerId")
            updateArtwork.setValue(collectionId, forKey: "collectionId")
            updateArtwork.setValue(objectId, forKey: "objectId")
            updateArtwork.setValue(title, forKey: "title")
            updateArtwork.setValue(artType, forKey: "artType")
            updateArtwork.setValue(date, forKey: "date")
            updateArtwork.setValue(medium, forKey: "medium")
            updateArtwork.setValue(description, forKey: "artDescription")
            updateArtwork.setValue(dimensions, forKey: "dimensions")
            updateArtwork.setValue(frameDimensions, forKey: "frameDimensions")
            updateArtwork.setValue(condition, forKey: "condition")
            updateArtwork.setValue(currentLocation, forKey: "currentLocation")
            updateArtwork.setValue(source, forKey: "source")
            updateArtwork.setValue(dateAcquired, forKey: "dateAcquired")
            updateArtwork.setValue(amountPaid, forKey: "amountPaid")
            updateArtwork.setValue(notes, forKey: "notes")
            updateArtwork.setValue(additionalInfoLabel, forKey: "additionalInfoLabel")
            updateArtwork.setValue(additionalInfoText, forKey: "additionalInfoText")
            updateArtwork.setValue(reviewedBy, forKey: "reviewedBy")
            updateArtwork.setValue(reviewedDate, forKey: "reviewedDate")
            updateArtwork.setValue(provenance, forKey: "provenance")
            updateArtwork.setValue(dateAcquiredLabel, forKey: "dateAcquiredLabel")
            updateArtwork.setValue(showGeneralInfo, forKey: "showGeneralInfo")
            updateArtwork.setValue(customTitle, forKey: "customTitle")
            
            // artist and GI arrays
//            updateArtwork.setValue(artistIds, forKey: "artistIds")
//            updateArtwork.setValue(generalInfoIds, forKey: "generalInfoIds")
            
            // images
            let mainImageNetwork = downloadImage(url: image)
            let notesImageNetwork = downloadImage(url: notesImage)
            let notesImageTwoNetwork = downloadImage(url: notesImageTwo)
            let additionalInfoImageNetwork = downloadImage(url: additionalInfoImage)
            let additionalInfoImageTwoNetwork = downloadImage(url: additionalInfoImageTwo)
            
            updateArtwork.setValue(mainImageNetwork, forKey: "image")
            updateArtwork.setValue(notesImageNetwork, forKey: "notesImage")
            updateArtwork.setValue(notesImageTwoNetwork, forKey: "notesImageTwo")
            updateArtwork.setValue(additionalInfoImageNetwork, forKey: "additionalInfoImage")
            updateArtwork.setValue(additionalInfoImageTwoNetwork, forKey: "additionalInfoImageTwo")

        } catch {
            print("Error updating artwork information = \(error)")
        }
            
        saveNewItem()
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new customer data to database = \(error)")
        }
    }
    
    private func downloadImage(url: String) -> String? {
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        
        let strBase64 =  imageData.base64EncodedString()
        return strBase64
    }
    
    private func createCustomer(id: String, fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String, createdAt: String) {

        let customerCreateService = CustomerCreateService()
        let state = "CO"

        progressHUD.show(onView: view, animated: true)
        customerCreateService.createCustomer(id: id, fName: fName, lName: lName, email: email, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes, createdAt: createdAt, updatedAt: createdAt) { [weak self] customerData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue posting customer data (Customer POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Customer POST request")

                if let customer = customerData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToCustomersSegue", sender: self)
                }
            }
        }
    }
    
    private func updateCustomer(id: String, fName: String, lName: String, email: String, phone: String, street: String, city: String, state: String, zip: String, referred: String, notes: String, createdAt: String, updatedAt: String) {

        let customerEditService = CustomerEditService()

        progressHUD.show(onView: view, animated: true)
        customerEditService.updateCustomer(id: id, fName: fName, lName: lName, email: email, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes, createdAt: createdAt, updatedAt: updatedAt) { [weak self] customerData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue putting customer data (Customer POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Customer PUT request")

                if let customer = customerData {
                    self.progressHUD.hide(onView: self.view, animated: true)
                    self.performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
                }
            }
        }
    }
    
    private func getCollectionInfo(collectionId: String, custId: UUID) {
        let getCollectionService = GetCollectionService()
        
        progressHUD.show(onView: view, animated: true)
        getCollectionService.getCollectionInfo(collectionId: collectionId) { [weak self] collectionData, error in
            guard let self = self else {
                return
            }
            
            defer {
                self.progressHUD.hide(onView: self.view, animated: true)
            }
            
            if let e = error {
                print("Issue getting collection info data (Collection GET request) - \(e)")
                return
            } else {
                if let collection = collectionData {
                    let name = collection.collectionName ?? ""
                    let identifier = collection.identifier ?? ""
                    let year = collection.year ?? ""
                    let createdAt = collection.createdAt
                    let updatedAt = collection.updatedAt
                    let id = UUID(uuidString: collectionId)!
                    let customerId = custId
                    let artArray = collection.artworks ?? []
                    
                    self.saveCollectionToCore(id: id, collectionName: name, identifier: identifier, year: year, custId: customerId, createdAt: createdAt, updatedAt: updatedAt, artwork: artArray)
                }
            }
        }
    }
    
    private func createArtworkInWeb(id: UUID, objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, customerId: UUID, collectionId: UUID, showGeneralInfo: Bool, createdAt: String, updatedAt: String) {

        let artworkCreateService = ArtworkCreateService()

        let artId = id.uuidString
        let customerId = customerId.uuidString
        let collectionId = collectionId.uuidString
        
        artworkCreateService.createArtwork(id: artId, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: provenance, customerId: customerId, collectionId: collectionId, artistId: "", generalInformationId: "", showGeneralInfo: showGeneralInfo, createdAt: createdAt, updatedAt: updatedAt) { [weak self] artworkData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue creating artwork data (artwork POST request) - \(e)")
                return
            } else {
                print("SUCCESS - artwork request")
            }
        }
    }
    
    private func updateArtworkInWeb(id: UUID, objectId: String, artType: String, title: String, date: String, medium: String, description: String, mainImage: String, dimensions: String, frameDimensions:  String, condition: String, currentLocation: String, source: String, dateAcquiredLabel: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, notesImageTwo: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalInfoImageTwo: String, reviewedBy: String, reviewedDate: String, provenance: String, customTitle: String, customerId: UUID, collectionId: UUID, showGeneralInfo: Bool, createdAt: String, updatedAt: String) {

        let artworkEditService = ArtworkEditService()
        let artId = id.uuidString
        let customerId = customerId.uuidString
        let collectionId = collectionId.uuidString
        
        artworkEditService.updateArtwork(id: artId, objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, showGeneralInfo: showGeneralInfo, createdAt: createdAt, updatedAt: updatedAt) { artworkData, error  in
            
            if let e = error {
                print("Issue updating artwork data (artwork PUT request) - \(e)")
                return
            } else {
                print("SUCCESS - artwork request")
            }
        }
    }
}

