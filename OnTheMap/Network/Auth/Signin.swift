//
//  Signin.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//

import Foundation
import UIKit

func signin(username: String, password: String, viewController: UIViewController) async -> String? {
    let body = SignInRequest(username: username, password: password)
    
    let result = await UdacityApi.shared.post(url: UdacityUrl.session, body: body, applyTransform: true, responseType: SignInResponse.self, viewController: viewController)
    
    var response: SignInResponse
    
    switch result {
    case .success(let _response):
        response = _response
        
        if response.error == nil {
            // get the first and last names
            await getName(response.account!.key, viewController: viewController)
            return nil
        } else {
            return response.error
        }
    case .failure(let error) :
        showError(viewController: viewController, message: error.localizedDescription)
        return error.localizedDescription
    }
}
