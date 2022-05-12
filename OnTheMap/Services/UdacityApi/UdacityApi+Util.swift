//
//  UdacityApi+Util.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation

extension UdacityApi {
    func getName(_ key: String) async {
        let result = await get(url: UdacityUrl.users, queryStrings: [], parameter: key, responseType: GetUserResponse.self, applyTransform: true)
        
        switch result {
        case .success(let response):
            
            firstName = response.first_name
            lastName = response.last_name
            
        case .failure(_) :
            print("getName failed")
        }
    }
    
    func clean(_ studentLocations: [StudentLocation]?) -> [StudentLocation]? {
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
            
            
            // sort
            sl.sort { $0.firstName < $1.firstName }
            
            return sl
        } else {
            return nil
        }
        
    }
    
}
