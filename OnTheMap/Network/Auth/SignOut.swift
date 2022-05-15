//
//  SignOut.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//

import Foundation
import UIKit

func signout(viewController: UIViewController) {
    (viewController
        .parent?
        .parent?
        .parent as! UINavigationController).popToRootViewController(animated: true)
}
