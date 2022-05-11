//
//  MyLinkViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/10/22.
//

import UIKit
import CoreLocation
import NanoID
class MyLinkViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var myLink: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
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
    
    func returnToRoot() {
        if let presentingViewController1 = presentingViewController {
            
            if let presentingViewController2 = presentingViewController1.presentingViewController {
                
                if let presentingViewController3 = presentingViewController2.presentingViewController {
                    presentingViewController3.dismiss(animated: true)
                    
                }
            }
        }
    }
    // MARK: - Actions
    @IBAction func cancelBtnPressed(_ sender: Any) {
        returnToRoot()
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveBtnPress(_ sender: Any) {
        Task {
            var firstName: String?
            var lastName: String?
            var signedInUserLocation: StudentLocation?
            
            guard let mediaURL = State.shared.getState(key: StateKey.mediaURL.rawValue),
                  let mapString = State.shared.getState(key: StateKey.mapString.rawValue),
                  let coordinate = State.shared.getState(key: StateKey.coordinate.rawValue) else {
                print("Error parsing state!")
                return
            }
            
            if var signedInUserLocationCurrent = await UdacityApi.shared.getSignedInStudentLocation() {
                // existing user
                signedInUserLocation = signedInUserLocationCurrent
               
            } else {
                // new user
                signedInUserLocation = StudentLocation(uniqueKey: NanoID.generate(), firstName: UdacityApi.shared.firstName!, lastName: UdacityApi.shared.lastName!, latitude: 0, longitude: 0, mapString: "", mediaURL: "")
            }
            
            
            signedInUserLocation!.mediaURL = mediaURL as! String
            signedInUserLocation!.mapString = mapString as! String
            signedInUserLocation!.latitude = (coordinate as! CLLocationCoordinate2D).latitude
            signedInUserLocation!.longitude = (coordinate as! CLLocationCoordinate2D).longitude
            
            activity.startAnimating()
            
            // save to the cloud
            await UdacityApi.shared.setSignedInStudentLocation(signedInUserLocation!)
            
            returnToRoot()
        }
    }
    
    // MARK: - UITextFieldDelegate
    @IBAction func myLinkChanged(_ sender: Any) {
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
