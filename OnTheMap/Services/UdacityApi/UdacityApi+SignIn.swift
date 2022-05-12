//
//  UdacityApi+SignIn.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation

extension UdacityApi {
    func signin(username: String, password: String) async -> String? {
        let body = SignInRequest(username: username, password: password)
        
        let result = await post(url: UdacityUrl.session, body: body, applyTransform: true, responseType: SignInResponse.self)
        
        var response: SignInResponse
        
        switch result {
        case .success(let _response):
            response = _response
            
            if response.error == nil {
                // get the first and last names
                await getName(response.account!.key)
                return nil
            } else {
                return response.error
            }
        case .failure(let error) :
            return error.localizedDescription
        }
        
    }
   
}
