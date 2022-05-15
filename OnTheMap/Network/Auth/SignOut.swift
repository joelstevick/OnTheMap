//
//  SignOut.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//

import Foundation
import UIKit

func signout(viewController: UIViewController) {
    
    Task {
        await UdacityApi.shared.delete(url: UdacityUrl.session, viewController: viewController)
        
        await (viewController
            .parent?
            .parent?
            .parent as! UINavigationController).popToRootViewController(animated: true)
    }
}
