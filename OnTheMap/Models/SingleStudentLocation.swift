//
//  SingleStudentLocation.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/8/22.
//

import Foundation

struct SingleStudentLocationUser: Codable {
    let key: String
    let last_name: String
    let first_name: String
    let website_url: String
    
}

struct SingleStudentLocation: Codable {
    let user: SingleStudentLocationUser
}
