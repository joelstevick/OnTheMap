//
//  UdacityApi+Util.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension UdacityApi {
    func getName(_ key: String, viewController: UIViewController) async {
        let result = await get(url: UdacityUrl.users, queryStrings: [], parameter: key, responseType: GetUserResponse.self, applyTransform: true, viewController: viewController)
        
        switch result {
        case .success(let response):
            
            firstName = response.first_name
            lastName = response.last_name
            
        case .failure(_) :
            showError(viewController: viewController, message: "Could not get the name")
        }
    }
}
