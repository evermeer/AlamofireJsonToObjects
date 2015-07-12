//
//  WordpressTest.swift
//  AlamofireJsonToObjects
//
//  Created by Edwin Vermeer on 7/11/15.
//  Copyright (c) 2015 evict. All rights reserved.
//
// Test for getting wordpress posts. For api documentation see:
// https://developer.wordpress.com/docs/api/

import UIKit
import XCTest
import Alamofire
import EVReflection

class Posts: EVObject {
    var found: Int = 0
    var posts: [Post] = [Post]()
    var meta: Meta?
    var error: String?
    var message: String?
}

class Post: EVObject {
    var ID: Int = 0
    var site_ID: Int = 0
    var author: Author?
    var date: String?
    var modified: String?
    var title: String?
    var URL: String?
    var short_URL: String?
    var content: String?
    var excerpt: String?
    var slug: String?
    var guid: String?
    var status: String?
    var sticky: Bool = false
    var password: String?
    var parent: Bool = false
    var type: String?
    var comments_open: Bool = false
    var pings_open: Bool = false
    var likes_enabled: Bool = false
    var sharing_enabled: Bool = false
    var comment_count: Int = 0
    var like_count: Int = 0
    var i_like: Bool = false
    var is_reblogged: Bool = false
    var is_following: Bool = false
    var global_ID: String?
    var featured_image: String?
    var format: String?
    var geo: Bool = false
    var menu_order: Int = 0
    var publicize_URLs: [String] = [String]()
    var tags: Tags?
    var categories: Categories?
    var attachments: Attachments?
    var metadata: [Metadata] = [Metadata]()
    var meta: Meta?
    var current_user_can: Capabilities?
    var capabilities: Capabilities?
    var post_thumbnail: Attachment?
    var page_template: String?
    var attachment_count: Int = 0
    var discussion: Discussion?
}

class Discussion: EVObject {
    var comments_open: Bool = false
    var comment_status: String?
    var pings_open: Bool = false
    var ping_status: String?
    var comment_count: Int = 0
}

class Meta: EVObject {
    var links: Links?
}

class Links: EVObject {
    var _self: String?
    var help: String?
    var site: String?
    var replies: String?
    var likes: String?
    var counts: String?
}

class Metadata: EVObject {
    var id: String?
    var key: String?
    var value: String?
}

class Author: EVObject {
    var ID: Int = 0
    var email: Bool = false
    var name: String?
    var URL: String?
    var avatar_URL: String?
    var profile_URL: String?
}


class Capabilities: EVObject {
    var publish_post: Bool = false
    var delete_post: Bool = false
    var edit_post: Bool = false
}


class Categories: EVObject {
    var categories = [Categorie]()
    
    // This way we can solve that the JSON uses values for keys
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if let dic = value as? NSDictionary {
            categories.append(Categorie(dictionary: dic))
            return
        }
        NSLog("---> setValue for key '\(key)' should be handled.")
    }
}

class Tags: EVObject {
    var tags = [Categorie]()
    
    // This way we can solve that the JSON uses values for keys
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if let dic = value as? NSDictionary {
            tags.append(Categorie(dictionary: dic))
            return
        }
        NSLog("---> setValue for key '\(key)' should be handled.")
    }
}

class Categorie: EVObject {
    var ID: Int = 0
    var name: String?
    var slug: String?
    var _description: String?
    var post_count: Int = 0
    var meta: Meta?
    var parent: Int = 0
}

class Attachments: EVObject {
    var IDs = [Attachment]()

    // This way we can solve that the JSON has numeric fields that are used as keys
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if let id = key.toInt(), dic = value as? NSDictionary {
            IDs.append(Attachment(dictionary: dic))
            return
        }
        NSLog("---> setValue for key '\(key)' should be handled.")
    }
}

class Attachment: EVObject {
    var ID: Int = 0
    var URL: String?
    var guid: String?
    var mime_type: String?
    var width: Int = 0
    var height: Int = 0
}




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