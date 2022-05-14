//
//  UdacityApi+Util.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension UdacityApi {
    func getName(_ key: String, viewController: UIViewController) async {
        let result = await get(url: UdacityUrl.users, queryStrings: [], parameter: key, responseType: GetUserResponse.self, applyTransform: true, viewController: viewController)
        
        switch result {
        case .success(let response):
            
            firstName = response.first_name
            lastName = response.last_name
            
        case .failure(_) :
            showError(viewController: viewController, message: "Could not get the name")
        }
    }
    
    func canonicalize(_ studentLocations: [StudentLocation]?) -> [StudentLocation]? {
        if var sl = studentLocations {
            // remove junk rows
            sl = sl.filter({ studentLocation in
                if let _ = URL(string: studentLocation.mediaURL) {
                    return studentLocation.firstName.count > 0
                } else {
                    return false
                }
            })
            
            // uniqueness
            var unique = [String: StudentLocation]()
            
            sl.forEach({ studentLocation in
                unique[studentLocation.uniqueKey!] = studentLocation
            })
            
            sl = []
            
            for (_, studentLocation) in unique {
                sl.append(studentLocation)
            }
            
            
            // sort in reverse chrono
            sl.sort { stringToDate(isoDate: $0.updatedAt) > stringToDate(isoDate: $1.updatedAt)  }
            
            return sl
        } else {
            return nil
        }
        
    }
    
}
