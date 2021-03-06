//
//  UdacityApi+Post.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension UdacityApi {
    func buildPostRequest<T: Encodable>(url: String, body: T) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try encoder.encode(body)
        
        return request
        
    }
    func post< T: Encodable, ResponseType: Decodable>
    (url: UdacityUrl, body: T, applyTransform: Bool, responseType: ResponseType.Type, viewController: UIViewController) async ->
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
                
                return .success(try decoder.decode(ResponseType.self, from: transformedData))
            } else {
                return .success(try decoder.decode(ResponseType.self, from: data))
            }
        } catch {
            showError(viewController: viewController, message: error.localizedDescription)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
}
