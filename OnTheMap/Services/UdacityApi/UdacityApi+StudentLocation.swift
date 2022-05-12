//
//  UdacityApi+StudentLocation.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/12/22.
//

import Foundation

extension UdacityApi {
    
      func getStudentLocations() async -> [StudentLocation]? {
          
          let result = await get(url: UdacityUrl.studentLocations, queryStrings: [], parameter: nil, responseType: StudentLocationResponse.self, applyTransform: false)
          
          switch result {
          case .success(let response):
              return clean(response.results)
              
          case .failure(_) :
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
      
      
}
