//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by joel.stevick on 5/4/22.
//
import MapKit
import XCTest
import NanoID

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
        
        let signinError = await UdacityApi.shared.signin(username: "joe-foo@bar.com", password: "xxx")
        
        if signinError == nil {
            XCTFail()
        }
    }
    
    func testSignIn_GivenGoodCreds_ShouldSucceed() async throws {
        
        let signinError = await UdacityApi.shared.signin(username: getEnvVar("UDACITY_USERNAME")!, password: getEnvVar("UDACITY_PASSWORD")!)
        
        if signinError != nil {
            XCTFail()
            
        }
    }
    
    func testGetStudentLocations_GivenWellFormedRequest_ShouldReturnStudentLocations() async throws  {
        let studentLocations = await UdacityApi.shared.getStudentLocations()
        
        if studentLocations == nil {
            XCTFail()
        }
    }
    
    func testStudentLocation_GivenUniqueKey_ShouldBeAbleToGetAndSet() async throws {
             
        // first, initialize a new student
        let studentLocation = StudentLocation(uniqueKey: nil, firstName: "Joe", lastName: "Foo", latitude: 1, longitude: 2, mapString: "somewhere", mediaURL: "https://google.com")
        
        await UdacityApi.shared.setSignedInStudentLocation(studentLocation)
        
        // get the student
        var savedStudentLocation = await UdacityApi.shared.getSignedInStudentLocation()
        
        // change the student first name
        savedStudentLocation?.firstName = NanoID.generate()
        
        // update in the cloud
        await UdacityApi.shared.setSignedInStudentLocation(savedStudentLocation!)
        
        // get the updated record
        let savedStudentLocation2 = await UdacityApi.shared.getSignedInStudentLocation()
        
        XCTAssertEqual(savedStudentLocation?.uniqueKey, savedStudentLocation2?.uniqueKey)
        XCTAssertEqual(savedStudentLocation?.firstName, savedStudentLocation2?.firstName)
        
    }
        
}
