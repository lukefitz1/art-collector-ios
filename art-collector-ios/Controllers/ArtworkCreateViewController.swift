//
//  ArtworkCreateViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtworkCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var objectIdTextField: UITextField!
    @IBOutlet weak var artTypeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mediumTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dimensionsTextField: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        imagePicker.allowsEditing = false
    }
    
    @IBAction func takeImageBtnPressed(_ sender: Any) {
        print("takeImageBtnPressed")
//        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // set image view to be the image you just took
            mainImageView.image = image
        }
    
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
