//
//  AddStudentLocationViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/8/22.
//

// steps in the process
import UIKit
import CoreLocation

enum Step: String {
    case collectMapString
    case collectLatLon
    case collectMediaURL
}

enum StateKey: String {
    case mapString
    case coordinate
    case mediaURL
}
class AddStudentLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unrecognizedLocation: UILabel!
    @IBOutlet weak var continueBtn: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var adjustForKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        unrecognizedLocation.isHidden = true
        
        // initialize step-state
        State.shared.reset()
        
        subscribeToKeyboardNotifications()
        
        update()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // restore state
        if let mapString = State.shared.getState(key: StateKey.mapString.rawValue) {
            textField.text = mapString as? String
        } else {
            // otherwise, initialize it from the current value (if any)
            Task {
                let signedInStudentLocation = await StudentLocations.shared.getSignedInStudentLocation(viewController: self)
                
                if let signedInStudentLocation = signedInStudentLocation {
                    textField.text = signedInStudentLocation.mapString
                    
                    DispatchQueue.main.async {
                        self.update()
                    }
                }
            }
            
        }
        
        update()
    }
    
    // MARK: - Textfield delegate
    @IBAction func textViewDidChange(_ textField: UITextField) {
        unrecognizedLocation.isHidden = true
        
        update()
    }
    // MARK: - Actions
    @IBAction func continueBtnPressed(_ sender: Any) {
        activityIndicatorView.startAnimating()
        
        // convert mapString to coords
        let mapString = textField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(mapString) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                self.unrecognizedLocation.isHidden = false
                return
            }
            
            // persist state
            State.shared.setState(key: StateKey.mapString.rawValue, value: mapString)
            State.shared.setState(key: StateKey.coordinate.rawValue, value: location.coordinate)
            
            self.activityIndicatorView.stopAnimating();
            
            // next step
            self.performSegue(withIdentifier: "CollectLatLon", sender: self)
        }
        
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
    // MARK: - Keyboard adjustments
    func textFieldDidBeginEditing(_ textField: UITextField) {
        adjustForKeyboard = true
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if adjustForKeyboard {
            view.frame.origin.y = -1 * getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil )
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    // MARK: - Utility methods
    func update() {
        if let text = textField.text {
            continueBtn.isEnabled = text.trimmingCharacters(in: CharacterSet.whitespaces).count > 0
        } else {
            continueBtn.isEnabled = false
        }
    }
}
