//
//  CustomerEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class CustomerEditViewController: UIViewController {
    
    var customer: Customer?
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var referredBy: UITextField!
    @IBOutlet weak var projectNotes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = customer?.firstName
        lastName.text = customer?.lastName
        emailAddress.text = customer?.email
        phoneNumber.text = customer?.phone
        streetAddress.text = customer?.address
        city.text = customer?.city
        state.text = customer?.state
        zipCode.text = customer?.zip
        referredBy.text = ""
        projectNotes.text = ""
    }
    
    @IBAction func updateCustomerBtnPressed(_ sender: Any) {
    
    }
}
