//
//  UdacityApi.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

enum UdacityApiError: Error {
    case Noop
}
class UdacityApi {
    static let shared = UdacityApi()
    
    private init() {
        
    }
    
    func signin(email: String, password: String) async -> Result<SignInResponse, Error> {
        
        return .failure(UdacityApiError.Noop)
    }
    
}
