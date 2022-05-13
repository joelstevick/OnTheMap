//
//  Udacity+Error.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/13/22.
//

import Foundation
import UIKit

extension UdacityApi {
    func showError(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
            
        }
        
    }
}
