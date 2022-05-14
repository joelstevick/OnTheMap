//
//  UdacityApi+SignOut.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/14/22.
//

import Foundation

extension UdacityApi {
    func signout() {
        defaults.removeObject(forKey: "uniqueKey")
        defaults.removeObject(forKey: "objectId")
    }
}
