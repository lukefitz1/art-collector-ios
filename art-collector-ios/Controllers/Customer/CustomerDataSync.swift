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
        let entity = NSEntityDescription.entity(forEntityName: "CustomerCore", in: context)!

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
                let newCustomer = NSManagedObject(entity: entity, insertInto: context)
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
                // let customerCollections = customer.collections

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
                            updateCustomer(id: cId, fName: cCustomerFirstName, lName: cCustomerLastName, email: cCustomerEmail, phone: cCustomerPhone, street: cCustomerAddress, city: cCustomerCity, zip: cCustomerZip, referred: "", notes: "", createdAt: cCreatedAt, updatedAt: cUpdatedAt)
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
//                            let networkReferredBy = customer.r ?? ""
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
    
    private func updateCustomer(id: String, fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String, createdAt: String, updatedAt: String) {

        let customerEditService = CustomerEditService()
        let state = "CO"

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

