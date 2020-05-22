//
//  CustomerEditViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/1/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CustomerEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var customer: Customer?
    var customerCore: CustomerCore?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        // Listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        streetAddressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        referredByTextField.delegate = self
        projectNotesTextView.delegate = self
        
        firstNameTextField.text = customerCore?.firstName
        lastNameTextField.text = customerCore?.lastName
        emailTextField.text = customerCore?.emailAddress
        phoneTextField.text = customerCore?.phoneNumber
        streetAddressTextField.text = customerCore?.streetAddress
        cityTextField.text = customerCore?.city
        stateTextField.text = customerCore?.state
        zipTextField.text = customerCore?.zip
        referredByTextField.text = ""
        projectNotesTextView.text = ""
        
        projectNotesTextView.layer.borderWidth = 0.5
        projectNotesTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true;
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func updateCustomerBtnPressed(_ sender: Any) {
        guard let customerCoreId = customerCore?.id else { return }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let streetAddress = streetAddressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let zip = zipTextField.text ?? ""
        let referredBy = referredByTextField.text ?? ""
        let projectNotes = projectNotesTextView.text ?? ""
        let updateDate = DateUtility.getFormattedDateAsString()
        
        updateCustomerCoreData(id: customerCoreId, firstName: firstName, lastName: lastName, email: email, phone: phone, address: streetAddress, city: city, zip: zip, referredBy: referredBy, projectNotes: projectNotes, updatedAt: updateDate)
    }
    
    private func updateCustomerCoreData(id: UUID, firstName: String, lastName: String, email: String, phone: String, address: String, city: String, zip: String, referredBy: String, projectNotes: String, updatedAt: String) {
        let request: NSFetchRequest<CustomerCore> = CustomerCore.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as NSUUID)
        progressHUD.show(onView: view, animated: true)
        do {
            let customer = try context.fetch(request)
            
            let updateCustomer = customer[0] as NSManagedObject
            updateCustomer.setValue(updatedAt, forKey: "updatedAt")
            updateCustomer.setValue(firstName, forKey: "firstName")
            updateCustomer.setValue(lastName, forKey: "lastName")
            updateCustomer.setValue(email, forKey: "emailAddress")
            updateCustomer.setValue(phone, forKey: "phoneNumber")
            updateCustomer.setValue(address, forKey: "streetAddress")
            updateCustomer.setValue(city, forKey: "city")
            updateCustomer.setValue(zip, forKey: "zip")
            updateCustomer.setValue(referredBy, forKey: "referredBy")
            updateCustomer.setValue(projectNotes, forKey: "projectNotes")
            
        } catch {
            print("Error updating customer information = \(error)")
        }
        
        saveUpdatedItem()
    }
    
    private func saveUpdatedItem() {
        do {
            try context.save()
            self.progressHUD.hide(onView: self.view, animated: true)
            self.performSegue(withIdentifier: "unwindToCustomerDetailSegue", sender: self)
        } catch {
            self.progressHUD.hide(onView: self.view, animated: true)
            print("Error saving the updated Customer to database = \(error)")
        }
    }
}

extension CustomerEditViewController {
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            view.frame.origin.y = -75
        }
        
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
    }
}
