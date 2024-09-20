//
//  MySpendTests.swift
//  MySpendTests
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import XCTest
//@testable import MySpend //Migrar a iOS 17

final class MySpendTests: XCTestCase {
    
    //This function allow us to declare or instanciate values or variables, before the tests run.
    //By default, Xcode adds "class" to this function. It has to be removed.
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    //This function runs after each Test run.
    //For example: Can be used to erase some storage in "UserDefaults".
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //All test function have to start with "test" in the function name.
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
