//
//  UdacityApi.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

enum UdacityApiError: Error {
    case Noop
    case NetworkError(description: String)
}

enum UdacityUrl: String {
    case session = "https://onthemap-api.udacity.com/v1/session"
    case studentLocations = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&skip=0"
    case createStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
    case users = "https://onthemap-api.udacity.com/v1/users"
}
class UdacityApi {
    static let shared = UdacityApi()
    let defaults = UserDefaults.standard
    var firstName: String?
    var lastName: String?
    var studentLocations: [StudentLocation]?
    
    private init() {}
}
