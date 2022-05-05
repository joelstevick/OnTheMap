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
}
class UdacityApi {
    static let shared = UdacityApi()
    
    private init() {
        
    }
    
    private func buildRequest<T: Encodable>(url: String, method: String, body: T) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        if method.uppercased() == "POST" {
            let encoder = JSONEncoder()
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try encoder.encode(body)
            
        }
        
        return request
        
    }
    private func sendRequest< T: Encodable, ResponseType: Decodable>
    (url: UdacityUrl,  method: String, body: T, responseType: ResponseType.Type) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let request = try buildRequest(url: url.rawValue, method: method, body: body)
            
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
            print(error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
    func signin(username: String, password: String) async -> Bool {
        let body = SignInRequest(username: username, password: password)
        
        let result = await sendRequest(url: UdacityUrl.session, method: "POST", body: body, responseType: SignInResponse.self)
        
        switch result {
        case .success(let response):
            if response.error == nil {
                return true
            } else {
                return false
            }
        case .failure(_) :
            return false
        }
        
    }
    
}
