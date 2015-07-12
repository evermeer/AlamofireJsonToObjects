//
//  WordpressTest.swift
//  AlamofireJsonToObjects
//
//  Created by Edwin Vermeer on 7/11/15.
//  Copyright (c) 2015 evict. All rights reserved.
//
// Test for getting wordpress posts. For api documentation see:
// https://developer.wordpress.com/docs/api/

import XCTest
import Alamofire

class WordpressTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testEvictNl() {
        let URL = "https://public-api.wordpress.com/rest/v1.1/sites/evict.nl/posts/"
        let expectation = expectationWithDescription("\(URL)")
        
        Alamofire.request(.GET, URL, parameters: nil)
            .responseObject { (response: Posts?, error: NSError?) in
                
                // That's all... Now test the data... TODO
                expectation.fulfill()
                println("\(response?.description)")
        }
        
        waitForExpectationsWithTimeout(30, handler: { (error: NSError!) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }


    func testGenseiryuNl() {
        let URL = "https://public-api.wordpress.com/rest/v1.1/sites/genseiryu.nl/posts/"
        let expectation = expectationWithDescription("\(URL)")
        
        Alamofire.request(.GET, URL, parameters: nil)
            .responseObject { (response: Posts?, error: NSError?) in
                
                // That's all... Now test the data... TODO
                expectation.fulfill()
                println("\(response?.description)")
        }
        
        waitForExpectationsWithTimeout(30, handler: { (error: NSError!) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }

    func testBlusMuchNl() {
        let URL = "https://public-api.wordpress.com/rest/v1.1/sites/www.blushmuch.nl/posts/"
        let expectation = expectationWithDescription("\(URL)")
        
        Alamofire.request(.GET, URL, parameters: nil)
            .responseObject { (response: Posts?, error: NSError?) in
                
                // That's all... Now test the data... TODO
                expectation.fulfill()
                println("\(response?.description)")
        }
        
        waitForExpectationsWithTimeout(30, handler: { (error: NSError!) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }

    
    
    
    
    
}