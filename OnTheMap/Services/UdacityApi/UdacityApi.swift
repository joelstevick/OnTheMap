//
//  UdacityApi.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation
import NanoID

enum UdacityApiError: Error {
    case Noop
    case NetworkError(description: String)
}

enum UdacityUrl: String {
    case session = "https://onthemap-api.udacity.com/v1/session"
    case studentLocations = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=0"
    case createStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
    case users = "https://onthemap-api.udacity.com/v1/users"
}
class UdacityApi {
    static let shared = UdacityApi()
    private let defaults = UserDefaults.standard
    var firstName: String?
    var lastName: String?
    
    private init() {
        
    }
    
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
    // MARK: - Api
    func signin(username: String, password: String) async -> String? {
        let body = SignInRequest(username: username, password: password)
        
        let result = await post(url: UdacityUrl.session, body: body, applyTransform: true, responseType: SignInResponse.self)
        
        var response: SignInResponse
        
        switch result {
        case .success(let _response):
            response = _response
            
            if response.error == nil {
                // get the first and last names
                await getName(response.account!.key)
                return nil
            } else {
                return response.error
            }
        case .failure(let error) :
            return error.localizedDescription
        }
        
    }
    
    func getStudentLocations() async -> [StudentLocation]? {
        
        let result = await get(url: UdacityUrl.studentLocations, queryStrings: [], parameter: nil, responseType: StudentLocationResponse.self, applyTransform: false)
        
        switch result {
        case .success(let response):
            return clean(response.results)
            
        case .failure(_) :
            return nil
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
    
    func getStudentLocation(_ uniqueKey: String) async -> StudentLocation? {
        let result = await get(url: UdacityUrl.studentLocations,queryStrings: ["uniqueKey=\(uniqueKey)"], parameter: nil,responseType: StudentLocationResponse.self, applyTransform: false)
        
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
