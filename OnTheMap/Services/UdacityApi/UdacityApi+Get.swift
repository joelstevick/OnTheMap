//
//  UdacityApi+Get.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation
import UIKit

extension UdacityApi {
    
    private func buildGetRequest(url: String) throws -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        return request
        
    }
    func get<ResponseType: Decodable>
    (url: UdacityUrl, queryStrings: [String], parameter: String? , responseType: ResponseType.Type,  applyTransform: Bool, viewController: UIViewController) async ->
    Result<ResponseType, UdacityApiError> {
        // execute
        do {
            var urlString = url.rawValue
            if (parameter != nil) {
                urlString += "/\(parameter!)"
            }
            urlString += "&" + queryStrings.joined(separator: "&")
            
            let request = try buildGetRequest(url: urlString)
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            
            showError(viewController: viewController, message: "No error")
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
