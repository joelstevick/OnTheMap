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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize state
        State.shared.reset()
        
    }
    
    // MARK: - Actions
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
}
