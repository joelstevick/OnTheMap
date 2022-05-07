//
//  UdacityApi.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

enum UdacityApiError: Error {
    case Noop
    case NetworkError(description: String)
}

private enum UdacityUrl: String {
    case session = "https://onthemap-api.udacity.com/v1/session"
    case studentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=0"
}
class UdacityApi {
    static let shared = UdacityApi()
    
    private init() {
        
    }
    
    // MARK: - GET utility functions
    private func buildGetRequest(url: String) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        return request
        
    }
    private func get<ResponseType: Decodable>
    (url: UdacityUrl, responseType: ResponseType.Type) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let request = try buildGetRequest(url: url.rawValue)
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            
            // required transformation for results
            let range = 5..<data.count
            let transformedData = data.subdata(in: range) /* subset response data! */
            
//            print(String(data: transformedData, encoding: .utf8)!)
            
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
    (url: UdacityUrl, body: T, responseType: ResponseType.Type) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let request = try buildPostRequest(url: url.rawValue, body: body)
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            
            // required transformation for results
            let range = 5..<data.count
            let transformedData = data.subdata(in: range) /* subset response data! */
            
            print(String(data: transformedData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            
            return .success(try decoder.decode(ResponseType.self, from: transformedData))
        } catch {
            print("ERROR", error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
    
    // MARK: - Api
    func signin(username: String, password: String) async -> String? {
        let body = SignInRequest(username: username, password: password)
        
        let result = await post(url: UdacityUrl.session, body: body, responseType: SignInResponse.self)
        
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
        
        let result = await get(url: UdacityUrl.studentLocation, responseType: StudentLocationResponse.self)
        
        print("RESULT", result)
        
        switch result {
        case .success(let response):
            return response.results
        case .failure(_) :
            return nil
        }
        
    }
    
}
