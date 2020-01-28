//
//  CustomerCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

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

        print("First name: \(firstName) - Last name: \(lastName) - Email: \(email) - Phone: \(phone) - Street Address: \(streetAddress) - City: \(city) - Zip: \(zip) - Referred by: \(referredBy)")

        createCustomer(fName: firstName, lName: lastName, email: email, phone: phone, street: streetAddress, city: city, zip: zip, referred: referredBy, notes: projectNotes)
        self.performSegue(withIdentifier: "unwindToCustomersSegue", sender: self)
    }

    private func createCustomer(fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String) {

        let customerCreateService = CustomerCreateService()

        let state = "CO"
        customerCreateService.createCustomer(fName: fName, lName: lName, email: lName, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes) { [weak self] customerData, error in
            guard let self = self else {
                return
            }

            if let e = error {
                print("Issue posting customer data (Customer POST request) - \(e)")
                return
            } else {
                print("SUCCESS - Customer POST request")

                if let customer = customerData {
                    print(customer)
                }
            }
        }
    }
}
