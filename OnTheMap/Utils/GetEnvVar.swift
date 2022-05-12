//
//  GetEnvVar.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/4/22.
//

import Foundation

func getEnvVar(_ key: String) -> String? {
     return ProcessInfo.processInfo.environment[key]
}
