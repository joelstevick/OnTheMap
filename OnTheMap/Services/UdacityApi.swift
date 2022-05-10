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

private enum UdacityUrl: String {
    case session = "https://onthemap-api.udacity.com/v1/session"
    case studentLocations = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=0"
    case createStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
}
class UdacityApi {
    static let shared = UdacityApi()
    let defaults = UserDefaults.standard
    
    private init() {
        
    }
    
    // MARK: - GET utility functions
    private func buildGetRequest(url: String) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        return request
        
    }
    private func get<ResponseType: Decodable>
    (url: UdacityUrl, queryStrings: [String], responseType: ResponseType.Type) async ->
    Result<ResponseType, UdacityApiError> {
        // execute
        do {
            let request = try buildGetRequest(url: url.rawValue + "&" + queryStrings.joined(separator: "&"))
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            
            let decoder = JSONDecoder()
            
            return .success(try decoder.decode(ResponseType.self, from: data))
        } catch {
            print("ERROR", error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
    
    // MARK: - POST utility functions
    private func buildPostRequest<T: Encodable>(url: String, body: T) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try encoder.encode(body)
        
        return request
        
    }
    private func post< T: Encodable, ResponseType: Decodable>
    (url: UdacityUrl, body: T, applyTransform: Bool, responseType: ResponseType.Type) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let decoder = JSONDecoder()
            
            let request = try buildPostRequest(url: url.rawValue, body: body)
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            
            if (applyTransform) {
                // required transformation for results
                let range = 5..<data.count
                let transformedData = data.subdata(in: range) /* subset response data! */
                
                print(String(data: transformedData, encoding: .utf8)!)
                
                return .success(try decoder.decode(ResponseType.self, from: transformedData))
            } else {
                return .success(try decoder.decode(ResponseType.self, from: data))
            }
        } catch {
            print("ERROR", error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
    private func put< T: Encodable, ResponseType: Decodable>
    (url: UdacityUrl, body: T,responseType: ResponseType.Type, parameter: String) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let decoder = JSONDecoder()
            
            var request = try buildPostRequest(url: "\(url.rawValue)/\(parameter)", body: body)
            request.httpMethod = "PUT"
           
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
        
            return .success(try decoder.decode(ResponseType.self, from: data))
            
        } catch {
            print("ERROR", error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
    
    // MARK: - Api
    func signin(username: String, password: String) async -> String? {
        let body = SignInRequest(username: username, password: password)
        
        let result = await post(url: UdacityUrl.session, body: body, applyTransform: true, responseType: SignInResponse.self)
        
        switch result {
        case .success(let response):
            if response.error == nil {
                return nil
            } else {
                return response.error
            }
        case .failure(let error) :
            return error.localizedDescription
        }
    }
    
    func getStudentLocations() async -> [StudentLocation]? {
        
        let result = await get(url: UdacityUrl.studentLocations, queryStrings: [], responseType: StudentLocationResponse.self)
        
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
                unique[studentLocation.uniqueKey] = studentLocation
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
        let result = await get(url: UdacityUrl.studentLocations,queryStrings: ["uniqueKey=\(uniqueKey)"], responseType: StudentLocationResponse.self)
        
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
    
    func setSignedInStudentLocation(_ studentLocation: StudentLocation) async {
        
        // first try PUT, since the record may already exist.  Otherwise, create it using POST
        defaults.set(studentLocation.uniqueKey, forKey: "uniqueKey")
        
        let result = await put(url: UdacityUrl.createStudentLocation, body: studentLocation, responseType: PutStudentResponse.self, parameter: studentLocation.uniqueKey)
        
        switch result {
        case .success(_):
            print ("PUT OK ")
        case .failure(_) :
            // put failed, try create
            let result2 = await post(url: UdacityUrl.createStudentLocation, body: studentLocation, applyTransform: false, responseType: CreateStudentResponse.self)
            
            switch result2 {
            case .success(let response):
                print ("POST OK ")
            case .failure(let error) :
                // try create
                print ("POSt Failed", error.localizedDescription)
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
