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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        unrecognizedLocation.isHidden = true
        
        // initialize step-state
        State.shared.reset()
        
        update()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // restore state
        if let mapString = State.shared.getState(key: StateKey.mapString.rawValue) {
            textField.text = mapString as? String
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
            
            // next step
            self.performSegue(withIdentifier: "CollectLatLon", sender: self)
        }
        
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        dismiss(animated: true)
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
