//
//  UdacityApi+SignOut.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/14/22.
//

import Foundation
import UIKit

extension UdacityApi {
    func signout(viewController: UIViewController) {
        (viewController
            .parent?
            .parent?
            .parent as! UINavigationController).popToRootViewController(animated: true)
    }
}
