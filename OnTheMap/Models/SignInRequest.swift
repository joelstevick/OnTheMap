//
//  SignInRequest.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

struct UdacitySignInBody: Codable {
    let username: String
    let password: String
}
struct SignInRequest: Codable {
    var udacity: UdacitySignInBody?
    
    init (username: String, password: String) {
        udacity = UdacitySignInBody(username: username, password: password)
    }
}
