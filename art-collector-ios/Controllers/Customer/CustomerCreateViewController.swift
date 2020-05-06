//
//  CustomerCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class CustomerCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var referredByTextField: UITextField!
    @IBOutlet weak var projectNotesTextView: UITextView!
    @IBOutlet weak var stateTextField: UILabel!
    
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedStateCode: String = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let stateArray: [String] = ["Alaska","Alabama","Arkansas","American Samoa","Arizona","California","Colorado","Connecticut","District of Columbia","Delaware","Florida","Georgia","Guam","Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky","Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota","Missouri","Mississippi","Montana","North Carolina","North Dakota","Nebraska","New Hampshire","New Jersey","New Mexico","Nevada","New York","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Virginia","Virgin Islands","Vermont","Washington","Wisconsin","West Virginia","Wyoming"]
    
    let stateCodeArray = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
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
        let stateCode = selectedStateCode
        let zip = zipTextField.text ?? ""
        let referredBy = referredByTextField.text ?? ""
        let projectNotes = projectNotesTextView.text ?? ""
        let createDate = DateUtility.getFormattedDateAsString()
        
        createCustomerCoreData(fName: firstName, lName: lastName, email: email, phone: phone, street: streetAddress, city: city, state: stateCode, zip: zip, referred: referredBy, notes: projectNotes, createdAt: createDate)
    }
    
    private func createCustomerCoreData(fName: String, lName: String, email: String, phone: String, street: String, city: String, state: String, zip: String, referred: String, notes: String, createdAt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "CustomerCore", in: context)!
        let newCustomer = NSManagedObject(entity: entity, insertInto: context)
        
        progressHUD.show(onView: view, animated: true)
        newCustomer.setValue(UUID(), forKey: "id")
        newCustomer.setValue(createdAt, forKey: "createdAt")
        newCustomer.setValue(createdAt, forKey: "updatedAt")
        newCustomer.setValue(fName, forKey: "firstName")
        newCustomer.setValue(lName, forKey: "lastName")
        newCustomer.setValue(email, forKey: "emailAddress")
        newCustomer.setValue(phone, forKey: "phoneNumber")
        newCustomer.setValue(street, forKey: "streetAddress")
        newCustomer.setValue(city, forKey: "city")
        newCustomer.setValue(state, forKey: "state")
        newCustomer.setValue(zip, forKey: "zip")
        newCustomer.setValue(referred, forKey: "referredBy")
        newCustomer.setValue(notes, forKey: "projectNotes")
        
        saveNewItem()
        self.progressHUD.hide(onView: self.view, animated: true)
        self.performSegue(withIdentifier: "unwindToCustomersSegue", sender: self)
    }
    
    private func saveNewItem() {
        do {
            try context.save()
        } catch {
            print("Error saving the new customer to database = \(error)")
        }
    }
    
    @IBAction func selectStateBtnTapped(_ sender: Any) {
        pickerView = UIPickerView.init()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        pickerView.setValue(UIColor.black, forKey: "textColor")
        pickerView.autoresizingMask = .flexibleWidth
        pickerView.contentMode = .center
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(pickerView)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStateCode = stateCodeArray[row]
        stateTextField.text = stateArray[row]
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        pickerView.removeFromSuperview()
    }
    
//    private func createCustomer(fName: String, lName: String, email: String, phone: String, street: String, city: String, zip: String, referred: String, notes: String) {
//
//        let customerCreateService = CustomerCreateService()
//        let state = "CO"
//
//        progressHUD.show(onView: view, animated: true)
//        customerCreateService.createCustomer(fName: fName, lName: lName, email: email, phone: phone, address: street, city: city, state: state, zip: zip, referredBy: referred, projectNotes: notes) { [weak self] customerData, error in
//            guard let self = self else {
//                return
//            }
//
//            if let e = error {
//                print("Issue posting customer data (Customer POST request) - \(e)")
//                return
//            } else {
//                print("SUCCESS - Customer POST request")
//
//                if let customer = customerData {
//                    self.progressHUD.hide(onView: self.view, animated: true)
//                    self.performSegue(withIdentifier: "unwindToCustomersSegue", sender: self)
//                }
//            }
//        }
//    }
}
