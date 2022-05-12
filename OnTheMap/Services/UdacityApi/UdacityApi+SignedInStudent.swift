//
//  UdacityApi+SignedInStudent.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import NanoID

extension UdacityApi {
    func persistSignedInStudentLocationUniqueKey(uniqueKey: String, objectId: String) {
        defaults.set(uniqueKey, forKey: "uniqueKey")
        defaults.set(objectId, forKey: "objectId")
    }
    func setSignedInStudentLocation(_ studentLocation: StudentLocation) async {
        
        if let objectId = defaults.string(forKey: "objectId") {
            // PUT existing
            let result = await put(url: UdacityUrl.createStudentLocation, body: studentLocation, responseType: PutStudentResponse.self, parameter: objectId)
            switch result {
            case .success(_):
                print ("PUT OK ")
            case .failure(let error) :
                // create failed
                print ("PUT Failed", error.localizedDescription)
            }
        } else {
            // POST to create
            var studentLocation2 = studentLocation
            studentLocation2.uniqueKey = NanoID.generate()
            let result = await post(url: UdacityUrl.createStudentLocation, body: studentLocation2, applyTransform: false, responseType: CreateStudentResponse.self)
            
            switch result {
            case .success(let response):
                persistSignedInStudentLocationUniqueKey(uniqueKey: studentLocation2.uniqueKey!, objectId: response.objectId)
                print ("POST OK ")
            case .failure(let error) :
                // create failed
                print ("POST Failed", error.localizedDescription)
            }
        }
        
    }
    
    func getSignedInStudentLocation() async -> StudentLocation? {
        if let uniqueKey = defaults.string(forKey: "uniqueKey") {
            
            let studentLocation = await getStudentLocation(uniqueKey)
            
            return studentLocation
            
        } else {
            return nil
        }
    }
    
}