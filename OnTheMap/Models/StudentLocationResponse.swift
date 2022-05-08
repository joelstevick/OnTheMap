//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/6/22.
//

import Foundation

struct StudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
}

struct StudentLocationResponse: Codable {
    let results: [StudentLocation]
}
