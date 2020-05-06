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
                    self.saveNetworkData(customerNetworkDataArray: customers)
                } else {
                    self.progressHUD.hide(onView: self.view, animated: true)
                }
            }
        }
    }
    
    func saveNetworkData(customerNetworkDataArray: [Customer]) {
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
                
                if customerCollections.count > 0 {
                    customerCollections.forEach { collection in
                        let id = collection.id
                        let name = collection.collectionName ?? ""
                        let identifier = collection.identifier ?? ""
                        let year = collection.year ?? ""
                        let customerId = collection.customerId ?? ""
                        let createdAt = collection.createdAt
                        let updatedAt = collection.updatedAt
                        let art = collection.artworks ?? []
                        
                        saveCollectionToCore(id: id, collectionName: name, identifier: identifier, year: year, custId: customerId, createdAt: createdAt, updatedAt: updatedAt)
                        
                        if art.count > 0 {
                            art.forEach { art in
                                let id = art.id
                                let objectId = art.objectId ?? ""
                                let title = art.title ?? ""
                                let artType = art.artType ?? ""
                                let date = art.date ?? ""
                                let medium = art.medium ?? ""
//                                    let image = art.image ?? ""
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
//                                    let notesImage = art.notesImage ?? ""
                                let additionalInfoLabel = art.additionalInfoLabel ?? ""
                                let additionalInfoText = art.additionalInfoText ?? ""
//                                    let additionalInfoImage = art.additionalInfoImage ?? ""
//                                    let additionalPdf = art.additionalPdf ?? ""
                                let reviewedBy = art.reviewedBy ?? ""
                                let reviewedDate = art.reviewedDate ?? ""
                                let provenance = art.provenance ?? ""
                                let dateAcquiredLabel = art.dateAcquiredLabel ?? ""
                                let artistId = art.artistId ?? ""
                                let collectionId = art.collectionId ?? ""
                                let customerId = art.customerId ?? ""
//                                    let notesImageTwo = art.notesImageTwo ?? ""
//                                    let additionalInfoImageTwo = art.additionalInfoImageTwo ?? ""
                                let generalInfoId = art.generalInfoId ?? ""
                                let showGeneralInfo = art.showGeneralInfo ?? false
                                let customTitle = art.customTitle ?? ""
                                let createdAt = art.createdAt
                                let updatedAt = art.updatedAt
                            
                                saveArtToCore(id: id, objectId: objectId, title: title, artType: artType, date: date, medium: medium, image: "", description: description, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: "", additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: "", additionalPdf: "", reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, dateAcquiredLabel: dateAcquiredLabel, artistId: artistId, collId: collectionId, custId: customerId, notesImageTwo: "", additionalInfoImageTwo: "", generalInfoId: generalInfoId, showGeneralInfo: showGeneralInfo, customTitle: customTitle, createdAt: createdAt, updatedAt: updatedAt)
                            }
                        }
                    }
                }
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

                        print("The updated at dates differ, let's make an update!")

                        if coreUpdatedAt > networkUpdatedAt {
                            print("Core is more recent")
                            print("Let's send an update to the web app")

                            // send network request to update web app
                            updateCustomer(id: cId, fName: cCustomerFirstName, lName: cCustomerLastName, email: cCustomerEmail, phone: cCustomerPhone, street: cCustomerAddress, city: cCustomerCity, state: cCustomerState, zip: cCustomerZip, referred: "", notes: "", createdAt: cCreatedAt, updatedAt: cUpdatedAt)
                        } else {
                            print("Network is more recent")
                            print("Let's update local database")

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
                    } else {
                         print("No difference, no updates necessary")
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
        saveLocalData(customerNetworkData: customerNetworkDataArray)
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
    }
    
    private func saveCollectionToCore(id: String, collectionName: String, identifier: String, year: String, custId: String, createdAt: String, updatedAt: String) {
        let collectionEntity = NSEntityDescription.entity(forEntityName: "CollectionCore", in: context)!
        let newCollection = NSManagedObject(entity: collectionEntity, insertInto: context)
        
        let collectionId = UUID(uuidString: id)
        let customerId = UUID(uuidString: custId)
        
        newCollection.setValue(collectionId, forKey: "id")
        newCollection.setValue(createdAt, forKey: "createdAt")
        newCollection.setValue(updatedAt, forKey: "updatedAt")
        newCollection.setValue(collectionName, forKey: "collectionName")
        newCollection.setValue(identifier, forKey: "identifier")
        newCollection.setValue(year, forKey: "year")
        newCollection.setValue(customerId, forKey: "customerId")
        
        saveNewItem()
    }

    private func saveArtToCore(id: String, objectId: String, title: String, artType: String, date: String, medium: String, image: String, description: String, dimensions: String, frameDimensions: String, condition: String, currentLocation: String, source: String, dateAcquired: String, amountPaid: String, currentValue: String, notes: String, notesImage: String, additionalInfoLabel: String, additionalInfoText: String, additionalInfoImage: String, additionalPdf: String, reviewedBy: String, reviewedDate: String, provenance: String, dateAcquiredLabel: String, artistId: String, collId: String, custId: String, notesImageTwo: String, additionalInfoImageTwo: String, generalInfoId: String, showGeneralInfo: Bool, customTitle: String, createdAt: String, updatedAt: String) {
        let artworkEntity = NSEntityDescription.entity(forEntityName: "ArtworkCore", in: context)!
        let newArtwork = NSManagedObject(entity: artworkEntity, insertInto: context)
        
        let artworkId = UUID(uuidString: id)
        let collectionId = UUID(uuidString: collId)
        let customerId = UUID(uuidString: custId)
        let artistId = UUID(uuidString: artistId)
        let generalInfoId = UUID(uuidString: generalInfoId)
        
        newArtwork.setValue(artworkId, forKey: "id")
        newArtwork.setValue(createdAt, forKey: "createdAt")
        newArtwork.setValue(updatedAt, forKey: "updatedAt")
        newArtwork.setValue(customerId, forKey: "customerId")
        newArtwork.setValue(collectionId, forKey: "collectionId")
        newArtwork.setValue(artistId, forKey: "artistId")
        newArtwork.setValue(generalInfoId, forKey: "generalInformationId")
        newArtwork.setValue(objectId, forKey: "objectId")
        newArtwork.setValue(title, forKey: "title")
        newArtwork.setValue(artType, forKey: "artType")
        newArtwork.setValue(date, forKey: "date")
        newArtwork.setValue(medium, forKey: "medium")
        newArtwork.setValue(image, forKey: "image")
        newArtwork.setValue(description, forKey: "artDescription")
        newArtwork.setValue(dimensions, forKey: "dimensions")
        newArtwork.setValue(frameDimensions, forKey: "frameDimensions")
        newArtwork.setValue(condition, forKey: "condition")
        newArtwork.setValue(currentLocation, forKey: "currentLocation")
        newArtwork.setValue(source, forKey: "source")
        newArtwork.setValue(dateAcquired, forKey: "dateAcquired")
        newArtwork.setValue(amountPaid, forKey: "amountPaid")
        newArtwork.setValue(notes, forKey: "notes")
        newArtwork.setValue(notesImage, forKey: "notesImage")
        newArtwork.setValue(additionalInfoLabel, forKey: "additionalInfoLabel")
        newArtwork.setValue(additionalInfoText, forKey: "additionalInfoText")
        newArtwork.setValue(additionalInfoImage, forKey: "additionalInfoImage")
//        newArtwork.setValue(additionalPdf, forKey: "additionalPdf")
        newArtwork.setValue(reviewedBy, forKey: "reviewedBy")
        newArtwork.setValue(reviewedDate, forKey: "reviewedDate")
        newArtwork.setValue(provenance, forKey: "provenance")
        newArtwork.setValue(dateAcquiredLabel, forKey: "dateAcquiredLabel")
        newArtwork.setValue(notesImageTwo, forKey: "notesImageTwo")
        newArtwork.setValue(additionalInfoImageTwo, forKey: "additionalInfoImageTwo")
        newArtwork.setValue(showGeneralInfo, forKey: "showGeneralInfo")
        newArtwork.setValue(customTitle, forKey: "customTitle")
        
        saveNewItem()
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new customers to database = \(error)")
        }
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
    
}

