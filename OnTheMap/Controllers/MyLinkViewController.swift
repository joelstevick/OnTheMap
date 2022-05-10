//
//  MyLinkViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/10/22.
//

import UIKit
import CoreLocation
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
    
    // MARK: - Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveBtnPress(_ sender: Any) {
        Task {
            var signedInUserLocation = await UdacityApi.shared.getSignedInStudentLocation()!
            
            guard let mediaURL = State.shared.getState(key: StateKey.mediaURL.rawValue),
                  let mapString = State.shared.getState(key: StateKey.mapString.rawValue),
                  let coordinate = State.shared.getState(key: StateKey.coordinate.rawValue) else {
                print("Error parsing state!")
                return
            }
            signedInUserLocation.mediaURL = mediaURL as! String
            signedInUserLocation.mapString = mapString as! String
            signedInUserLocation.latitude = (coordinate as! CLLocationCoordinate2D).latitude
            signedInUserLocation.longitude = (coordinate as! CLLocationCoordinate2D).longitude
            
            activity.startAnimating()
            
            // save to the cloud
            await UdacityApi.shared.setSignedInStudentLocation(signedInUserLocation)
            
            dismiss(animated: true)
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
