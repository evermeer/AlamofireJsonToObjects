//
//  NestedGenericsIssue25.swift
//  AlamofireJsonToObjects
//
//  Created by Edwin Vermeer on 8/3/16.
//  Copyright © 2016 evict. All rights reserved.
//


import XCTest
import Alamofire
import EVReflection


class BaseModel: EVObject {
}

class ResponseModel<T: BaseModel>: EVObject, EVGenericsKVC {
    required init() {
        super.init()
    }

    var success: String?
    var reason: String?
    var content: [T]?

    internal override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if(key == "content") {
            content = value as? [T]
        }
    }

    internal func getGenericType() -> NSObject {
        return T()
    }
}


class PagerModel<T: BaseModel>: BaseModel, EVGenericsKVC {
    required init() {
        super.init()
    }

    var total: String?
    var per_page: String?
    var current_page: String?
    var last_page: String?
    var next_page_url: String?
    var prev_page_url: String?
    var from: String?
    var to: String?
    var data: [T]?

    internal  override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if(key == "data") {
            data = value  as? [T]
        }
    }

    internal func getGenericType() -> NSObject {
        return T()
    }
}

class NewsHeader: BaseModel {
    var id: String?
    var Description: String?
    var newsTypeId: String?
    var newsOrder: String?
    var isCommentActive: String?
    var placeTypeId: String?
    var link: String?
    var title: String?
    var pubDate: String?
    var imageUrl: String?
    var imageThumUrl: String?
    var appId: String?
    var projectId: String?
    var isValid: String?
    var created_at: String?
    var updated_at: String?
}

protocol ResponseListener: class {
    func onResponseSuccess<T: BaseModel>(result: ResponseModel<T>)
    func onResponseFail(error: NSError)
}

class BaseWebServices<T: BaseModel> : NSObject {
    let BASE_URL: String! = "http://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/"
    var listener: ResponseListener?

    func executeService(serviceUrl: String, method: Alamofire.Method, parameters: [String: AnyObject]) {
        let URL: String = "\(self.BASE_URL)\(serviceUrl)"
        Alamofire.request(method, URL, parameters:parameters)
            .responseObject { (response: Result<ResponseModel<T>, NSError>) in
                switch response {
                case .Success( _)  :
                    if let result: ResponseModel<T> = response.value {
                        print("result = \(result)")
                        self.listener?.onResponseSuccess(result)
                    }
                    break
                case .Failure(let error) :
                    print("error = \(error)")
                    self.listener?.onResponseFail(error)
                    break
                }
        }
    }
}


class NewsHeaderService: BaseWebServices<PagerModel<NewsHeader>>, ResponseListener {
    override  init() {
        super.init()
        super.listener = self
        executeService("NestedGenericsIssue25_json", method: .GET, parameters: ["token": "testtoken"])
    }

    // This initializer is just to let the test continue
    var continueTest: (() -> ())?
    convenience init(continueTest: () -> ()) {
        self.init()
        self.continueTest = continueTest
    }


    func onResponseSuccess<T: BaseModel>(response: ResponseModel<T>) {
        continueTest?()
    }

    func onResponseFail(failMessage: NSError) {
        continueTest?()
    }
}



class NestedGenericsIssue25: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        EVReflection.setBundleIdentifier(BaseModel)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testResponseObject() {
        let expectation = expectationWithDescription("test")

        let _: NewsHeaderService = NewsHeaderService() {
            expectation.fulfill()
        }

        // Fail if the test takes longer than 10 seconds.
        waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }
}
