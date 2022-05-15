//
//  UdacityApi+Delete.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/15/22.
//
import Foundation
import UIKit

extension UdacityApi {
    func delete
    (url: UdacityUrl, viewController: UIViewController) async {
        do {
            var request = URLRequest(url: URL(string: url.rawValue)!)
            request.httpMethod = "DELETE"
            
            // send the request over the wire
            let session = URLSession.shared
            let (_, _) =  try await session.data(for: request as URLRequest)
            
        } catch {
            showError(viewController: viewController, message: error.localizedDescription)
        }
    }
}
