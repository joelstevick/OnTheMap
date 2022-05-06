//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/6/22.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let latitude: String
    let longitude: String
    let mapString: String
    let mediaURL: String
}
