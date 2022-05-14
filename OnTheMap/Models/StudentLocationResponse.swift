//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/6/22.
//

import Foundation

struct StudentLocation: Codable {
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var updatedAt: String
}

struct StudentLocationResponse: Codable {
    let results: [StudentLocation]
}
