//
//  State.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/9/22.
//

import Foundation

enum StateChanges: String {
    case signedInStudentLocation
}

class State {
    static let shared = State()
    
    var state = [String: Any]()
    
    private init() {
        
    }
    
    func getState(key: String) -> Any? {
        return state[key]
    }
    
    func setState(key: String, value: Any) {
        state[key] = value
    }
    
    func reset() {
        state.removeAll()
    }
}
