//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by joel.stevick on 5/4/22.
//

import XCTest
@testable import OnTheMap

// The main purpose of these integration tests is to TDD the api
class OnTheMapTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignIn_GivenBadCreds_ShouldFail() async throws {
        
        let result = await UdacityApi.shared.signin(username: "joe-foo@bar.com", password: "xxx")
        
        switch result {
        case .success(_):
            XCTFail()
        case .failure(_): break
        }
    }
    
    func testSignIn_GivenGoodCreds_ShouldSucceed() async throws {
        
        let result = await UdacityApi.shared.signin(username: getEnvVar("UDACITY_USERNAME")!, password: getEnvVar("UDACITY_PASSWORD")!)
        
        switch result {
        case .success(_): break
            
        case .failure(_):
            XCTFail()
        }
    }
    
}
