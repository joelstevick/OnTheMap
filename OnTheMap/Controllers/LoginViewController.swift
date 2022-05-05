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
        
        async {
            let signedInOk = await UdacityApi.shared.signin(username: email.text!, password: password.text!)
            
            print (signedInOk)
        }
    }
    
}

