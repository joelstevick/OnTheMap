//
//  Udacity+Put.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation

extension UdacityApi {
    func put< T: Encodable, ResponseType: Decodable>
    (url: UdacityUrl, body: T,responseType: ResponseType.Type, parameter: String) async ->
    Result<ResponseType, UdacityApiError> {
        do {
            let decoder = JSONDecoder()
            
            var request = try buildPostRequest(url: "\(url.rawValue)/\(parameter)", body: body)
            request.httpMethod = "PUT"
            
            // send the request over the wire
            let session = URLSession.shared
            let (data, _) =  try await session.data(for: request as URLRequest)
            print(String(data: data, encoding: .utf8)!)
            
            return .success(try decoder.decode(ResponseType.self, from: data))
            
        } catch {
            print("ERROR", error)
            return .failure(.NetworkError(description: "Unknown error"))
        }
    }
}
