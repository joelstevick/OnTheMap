//
//  ViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Actions
    @IBAction func loginPressed(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        Task {
            let signinError = await UdacityApi.shared.signin(username: email.text!, password: password.text!)
            
            self.activityIndicator.stopAnimating()
            
            if let signinError = signinError {
                showLoginFailure(message: signinError)
            } else {
               navigateToMapView()
            }
        }
    }
    
    func navigateToMapView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    func showLoginFailure(message: String) {
        errorMessage.text = message
        errorMessage.isHidden = false
    }
}

