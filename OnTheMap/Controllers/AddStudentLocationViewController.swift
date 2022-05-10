//
//  AddStudentLocationViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/8/22.
//

// steps in the process

enum Step: String {
    case collectMapString
    case collectLatLon
    case collectMediaURL
}

import UIKit

class AddStudentLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        continueBtn.isEnabled = false
        
        // initialize step-state
        State.shared.reset()
        
    }
    
    // MARK: - Textfield delegate
    @IBAction func textViewDidChange(_ textField: UITextField) {
        if let text = textField.text {
            continueBtn.isEnabled = text.trimmingCharacters(in: CharacterSet.whitespaces).count > 0
        } else {
            continueBtn.isEnabled = false
        }
    }
    // MARK: - Actions
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
}
