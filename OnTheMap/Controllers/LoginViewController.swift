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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }
    
    func showLoginFailure(message: String) {
        
    }
}

