//
//  AlamofireJsonToObjectsTests.swift
//  AlamofireJsonToObjectsTests
//
//  Created by Edwin Vermeer on 6/21/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import UIKit
import XCTest
import Alamofire
import EVReflection

class WeatherResponse: EVObject {
    var location: String?
    var three_day_forecast: [Forecast] = [Forecast]()
}

class Forecast: EVObject {
    var day: String?
    var temperature: NSNumber?
    var conditions: String?
}


class AlamofireJsonToObjectsTests: XCTestCase {
    
        override func setUp() {
            super.setUp()
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            super.tearDown()
        }

    
        func testResponseObject() {
            // This is an example of a functional test case.
            let URL = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_json"
            let expectation = expectationWithDescription("\(URL)")
            
            Alamofire.request(.GET, URL, parameters: nil)
                .responseObject { (response: WeatherResponse?, error: NSError?) in
                
                expectation.fulfill()
                println("\(response?.description)")
                XCTAssertNotNil(response, "Response should not be nil")
                XCTAssertNotNil(response?.location, "Location should not be nil")
                XCTAssertNotNil(response?.three_day_forecast, "ThreeDayForcast should not be nil")
                for forecast in response!.three_day_forecast {
                    XCTAssertNotNil(forecast.day, "day should not be nil")
                    XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                    XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                }
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError!) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }
    
    
        func testResponseObject2() {
            // This is an example of a functional test case.
            
            let URL = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_json"
            let expectation = expectationWithDescription("\(URL)")
            
            Alamofire.request(.GET, URL, parameters: nil)
                .responseObject { (request: NSURLRequest, HTTPURLResponse: NSHTTPURLResponse?, response: WeatherResponse?, data: AnyObject?, error: NSError?) in
                    
                expectation.fulfill()
                
                XCTAssertNotNil(response, "Response should not be nil")
                XCTAssertNotNil(response?.location, "Location should not be nil")
                XCTAssertNotNil(response?.three_day_forecast, "ThreeDayForcast should not be nil")
                
                for forecast in response!.three_day_forecast {
                    XCTAssertNotNil(forecast.day, "day should not be nil")
                    XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                    XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                }
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError!) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }
        
        func testArrayResponseObject() {
            // This is an example of a functional test case.
            let URL = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_array_json"
            let expectation = expectationWithDescription("\(URL)")
            
            Alamofire.request(.GET, URL, parameters: nil)
                .responseArray { (response: [Forecast]?, error: NSError?) in
                expectation.fulfill()
                
                XCTAssertNotNil(response, "Response should not be nil")
                
                for forecast in response! {
                    XCTAssertNotNil(forecast.day, "day should not be nil")
                    XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                    XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                }
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError!) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }
        
        func testArrayResponseObject2() {
            // This is an example of a functional test case.
            let URL = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_array_json"
            let expectation = expectationWithDescription("\(URL)")
            
            Alamofire.request(.GET, URL, parameters: nil)
                .responseArray { (request: NSURLRequest, HTTPURLResponse: NSHTTPURLResponse?, response: [Forecast]?, data: AnyObject?, error: NSError?) in
                expectation.fulfill()
                
                XCTAssertNotNil(response, "Response should not be nil")
                
                for forecast in response! {
                    XCTAssertNotNil(forecast.day, "day should not be nil")
                    XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                    XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
                }
            }
            
            waitForExpectationsWithTimeout(10, handler: { (error: NSError!) -> Void in
                XCTAssertNil(error, "\(error)")
            })
        }
    }
    
