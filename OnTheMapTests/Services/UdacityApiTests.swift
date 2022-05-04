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
      
        let result = await UdacityApi.shared.signin(email: "joe@foo.com", password: "***")
        
        switch result {
        case .success():
            XCTFail()
        case .failure():
            // success
            print("success!")
        }
    }

}