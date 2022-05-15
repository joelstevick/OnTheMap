//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//

import Foundation

class StudentLocations {
    
    var studentLocations: [StudentLocation]?
    let defaults = UserDefaults.standard
    var firstName: String?
    var lastName: String?
    
    static let shared = StudentLocations()
    
    private init() {
        
    }
}
