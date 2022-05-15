//
//  GetName.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//

import Foundation
import UIKit

func getName(_ key: String, viewController: UIViewController) async {
    let result = await UdacityApi.shared.get(url: UdacityUrl.users, queryStrings: [], parameter: key, responseType: GetUserResponse.self, applyTransform: true, viewController: viewController)
    
    switch result {
    case .success(let response):
        
        StudentLocations.shared.firstName = response.first_name
        StudentLocations.shared.lastName = response.last_name
        
    case .failure(_) :
        showError(viewController: viewController, message: "Could not get the name")
    }
}
