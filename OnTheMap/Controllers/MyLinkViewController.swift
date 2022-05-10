//
//  MyLinkViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/10/22.
//

import UIKit

class MyLinkViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var myLink: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mediaURL = State.shared.getState(key: StateKey.mediaURL.rawValue)
        
        if let mediaURL = mediaURL {
            myLink.text = mediaURL as? String
        }
        
        update()
    }
    
    // MARK: - Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
    }
    
    // MARK: - UITextFieldDelegate
    @IBAction func textViewDidChange(_ textField: UITextField) {
        persist()
    
        update()
        
    }
    
    // MARK: - Utility methods
    func update() {
        let mediaURL = myLink.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        saveBtn.isEnabled = mediaURL.count > 0
    }
    
    func persist() {
        let mediaURL = myLink.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        State.shared.setState(key: StateKey.mediaURL.rawValue, value: mediaURL)
        
    }
}
