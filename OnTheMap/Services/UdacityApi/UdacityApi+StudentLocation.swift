//
//  UdacityApi+StudentLocation.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension UdacityApi {
    
    func getStudentLocations(refresh: Bool, viewController: UIViewController) async -> [StudentLocation]? {
        
        // cached?
        if let studentLocations = studentLocations {
            return studentLocations
        } else {
            let result = await get(url: UdacityUrl.studentLocations, queryStrings: [], parameter: nil, responseType: StudentLocationResponse.self, applyTransform: false, viewController: viewController)
            
            switch result {
            case .success(let response):
                
                var studentLocations = response.results
                let signedInUserLocation = await UdacityApi.shared.getSignedInStudentLocation(viewController: viewController)
                
                if let signedInUserLocation = signedInUserLocation {
                    studentLocations.append(signedInUserLocation)
                }
                
                studentLocations = canonicalize(studentLocations)!
                
                return studentLocations
                
            case .failure(_) :
                return nil
            }
        }
    }
    
    func getStudentLocation(_ uniqueKey: String, viewController: UIViewController) async -> StudentLocation? {
        let result = await get(url: UdacityUrl.studentLocations,queryStrings: ["uniqueKey=\(uniqueKey)"], parameter: nil,responseType: StudentLocationResponse.self, applyTransform: false, viewController: viewController)
        
        switch result {
        case .success(let response):
            let list = response.results
            
            if list.count > 0 {
                return list[0]
            } else {
                return nil
            }
            
        case .failure(_) :
            return nil
        }
    }
    
    
}
