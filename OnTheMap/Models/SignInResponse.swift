//
//  SIgnInResponse.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct SignInResponse: Codable {
    let account: Account?
    let session: Session?
    
    // error properties
    let status: Int?
    let error: String?
}
