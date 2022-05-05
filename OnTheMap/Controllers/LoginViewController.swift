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
    
    // MARK: - Actions
    @IBAction func loginPressed(_ sender: UIButton) {
        
        Task {
            let signinError = await UdacityApi.shared.signin(username: email.text!, password: password.text!)
            
            if let signinError = signinError {
                showLoginFailure(message: signinError)
            } else {
                performSegue(withIdentifier: "mapview", sender: self)
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

