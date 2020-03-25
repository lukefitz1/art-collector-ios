//
//  CustomerEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CustomerEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var customer: Customer?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var referredByTextField: UITextField!
    @IBOutlet weak var projectNotesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = customer?.firstName
        lastNameTextField.text = customer?.lastName
        emailTextField.text = customer?.email
        phoneTextField.text = customer?.phone
        streetAddressTextField.text = customer?.address
        cityTextField.text = customer?.city
        stateTextField.text = customer?.state
        zipTextField.text = customer?.zip
        referredByTextField.text = ""
        projectNotesTextView.text = ""
    }
    
    @IBAction func updateCustomerBtnPressed(_ sender: Any) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let streetAddress = streetAddressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let zip = zipTextField.text ?? ""
        let referredBy = referredByTextField.text ?? ""
        let projectNotes = projectNotesTextView.text ?? ""
        let customerId = customer?.id ?? ""
        
//        updateCustomer(id: customerId, fName: firstName, lName: lastName, email: email, phone: phone, street: streetAddress, city: city, zip: zip, referred: referredBy, notes: projectNotes)
    }
    
//    private func updateCustomer(id: String, fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String) {
//
//        let customerEditService = CustomerEditService()
//        let state = "CO"
//
//        progressHUD.show(onView: view, animated: true)
//        customerEditService.updateCustomer(id: id, fName: fName, lName: lName, email: email, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes) { [weak self] customerData, error in
//            guard let self = self else {
//                return
//            }
//
//            if let e = error {
//                print("Issue putting customer data (Customer POST request) - \(e)")
//                return
//            } else {
//                print("SUCCESS - Customer PUT request")
//
//                if let customer = customerData {
//                    self.progressHUD.hide(onView: self.view, animated: true)
//                    self.performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
//                }
//            }
//        }
//    }
}
