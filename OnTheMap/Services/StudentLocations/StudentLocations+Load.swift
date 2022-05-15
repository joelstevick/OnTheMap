//
//  UdacityApi+StudentLocation.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension StudentLocations {
    
    func loadStudentLocations(refresh: Bool, viewController: UIViewController) async {
        
        // cached?
        if let _ = studentLocations {
            return
        } else {
            let result = await UdacityApi.shared.get(url: UdacityUrl.studentLocations, queryStrings: [], parameter: nil, responseType: StudentLocationResponse.self, applyTransform: false, viewController: viewController)
            
            switch result {
            case .success(let response):
                
                studentLocations = response.results
                let signedInUserLocation = await getSignedInStudentLocation(viewController: viewController)
                
                if let signedInUserLocation = signedInUserLocation {
                    studentLocations!.append(signedInUserLocation)
                }
                
                studentLocations = canonicalize(studentLocations)!
                
                return
                
            case .failure(_) :
                showError(viewController: viewController, message: "Could not get users")
                return
            }
        }
    }
    
    func getStudentLocation(_ uniqueKey: String, viewController: UIViewController) async -> StudentLocation? {
        let result = await UdacityApi.shared.get(url: UdacityUrl.studentLocations,queryStrings: ["uniqueKey=\(uniqueKey)"], parameter: nil,responseType: StudentLocationResponse.self, applyTransform: false, viewController: viewController)
        
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
