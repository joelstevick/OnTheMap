//
//  UdacityApi+SignedInStudent.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import NanoID
import UIKit
import CoreLocation

extension StudentLocations {
    func persistSignedInStudentLocationUniqueKey(uniqueKey: String, objectId: String) {
        defaults.set(uniqueKey, forKey: "uniqueKey")
        defaults.set(objectId, forKey: "objectId")
    }
    func setSignedInStudentLocation(_ studentLocation: StudentLocation, viewController: UIViewController) async {
        
        if let objectId = defaults.string(forKey: "objectId") {
            // PUT existing
            let result = await UdacityApi.shared.put(url: UdacityUrl.createStudentLocation, body: studentLocation, responseType: PutStudentResponse.self, parameter: objectId, viewController: viewController)
            switch result {
            case .success(_):
                print ("PUT OK ")
            case .failure(let error) :
                // create failed
                showError(viewController: viewController, message: error.localizedDescription)
            }
        } else {
            // POST to create
            var studentLocation2 = studentLocation
            studentLocation2.uniqueKey = NanoID.generate()
            let result = await UdacityApi.shared.post(url: UdacityUrl.createStudentLocation, body: studentLocation2, applyTransform: false, responseType: CreateStudentResponse.self, viewController: viewController)
            
            switch result {
            case .success(let response):
                persistSignedInStudentLocationUniqueKey(uniqueKey: studentLocation2.uniqueKey!, objectId: response.objectId)
                print ("POST OK ")
            case .failure(let error) :
                // create failed
                showError(viewController: viewController, message: error.localizedDescription)
            }
        }
        
    }
    
    func getSignedInStudentLocation(viewController: UIViewController) async -> StudentLocation? {
        if let uniqueKey = defaults.string(forKey: "uniqueKey") {
            
            let studentLocation = await getStudentLocation(uniqueKey, viewController: viewController)
            
            // store in state
            if let latitude = studentLocation?.latitude, let longitude = studentLocation?.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                State.shared.setState(key: StateKey.coordinate.rawValue, value: coordinate)

            }
           
            if let mapString = studentLocation?.mapString {
                State.shared.setState(key: StateKey.mapString.rawValue, value: mapString)
            }
            
            if let mediaURL = studentLocation?.mediaURL {
                State.shared.setState(key: StateKey.mediaURL.rawValue, value: mediaURL)

            }
            
            return studentLocation
            
        } else {
            return nil
        }
    }
    
}
