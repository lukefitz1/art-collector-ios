//
//  CustomerCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CustomerCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var referredByTextField: UITextField!
    @IBOutlet weak var projectNotesTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        streetAddressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        referredByTextField.delegate = self
        projectNotesTextView.delegate = self

        projectNotesTextView.layer.borderWidth = 0.5
        projectNotesTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func addCustomerBtnPressed(_ sender: Any) {

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let streetAddress = streetAddressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let zip = zipTextField.text ?? ""
        let referredBy = referredByTextField.text ?? ""
        let projectNotes = projectNotesTextView.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
//        createCustomerCoreData(fName: firstName, lName: lastName, email: email, phone: phone, street: streetAddress, city: city, zip: zip, referred: referredBy, notes: projectNotes, createdAt: createDate)
        createCustomer(fName: firstName, lName: lastName, email: email, phone: phone, street: streetAddress, city: city, zip: zip, referred: referredBy, notes: projectNotes)
    }

    private func createCustomer(fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String) {

        let customerCreateService = CustomerCreateService()
        let state = "CO"
        
        progressHUD.show(onView: view, animated: true)
        customerCreateService.createCustomer(fName: fName, lName: lName, email: email, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes) { [weak self] customerData, error in
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
    
    private func createCustomerCoreData(fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String, createdAt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "CustomerCore", in: context)!
        let newCustomer = NSManagedObject(entity: entity, insertInto: context)
        
        newCustomer.setValue(UUID(), forKey: "id")
        newCustomer.setValue(createdAt, forKey: "createdAt")
        newCustomer.setValue(createdAt, forKey: "updatedAt")
        newCustomer.setValue(fName, forKey: "firstName")
        newCustomer.setValue(lName, forKey: "lastName")
        newCustomer.setValue(email, forKey: "emailAddress")
        newCustomer.setValue(phone, forKey: "phoneNumber")
        newCustomer.setValue(street, forKey: "streetAddress")
        newCustomer.setValue(city, forKey: "city")
        newCustomer.setValue(zip, forKey: "zip")
        newCustomer.setValue(referred, forKey: "referredBy")
        newCustomer.setValue(notes, forKey: "projectNotes")
        
        saveNewItem()
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new customer to database = \(error)")
        }
    }
}
