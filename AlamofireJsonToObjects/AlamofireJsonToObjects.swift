//
//  AlamofireJsonToObjects.swift
//  AlamofireJsonToObjects
//
//  Created by Edwin Vermeer on 6/21/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import Foundation
import EVReflection
import Alamofire

extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set,ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request
    
    - returns: The request.
    */
    public func responseObject<T:EVObject>(encoding: NSStringEncoding? = nil, completionHandler: (Result<T, NSError>) -> Void) -> Self {
        return responseObject(encoding: encoding) { (request, response, data: Alamofire.Result<T, NSError>) -> Void in
            completionHandler(data)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter queue: The queue on which the completion handler is dispatched.
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set,ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.
    
    - returns: The request.
    */
    public func responseObject<T:EVObject>(queue: dispatch_queue_t? = nil, encoding: NSStringEncoding? = nil, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T, NSError>) -> Void) -> Self {
        return responseString(encoding: encoding, completionHandler: { (response) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(queue ?? dispatch_get_main_queue()) {
                    switch response.result {
                    case .Success(let json):
                        let t = T()
                        let jsonDict = EVReflection.dictionaryFromJson(json)
                        EVReflection.setPropertiesfromDictionary(jsonDict, anyObject: t)
                        completionHandler(self.request, self.response, Result.Success(t))
                    case .Failure(let error):
                        completionHandler(self.request, self.response, Result.Failure(error ?? NSError(domain: "NaN", code: 1, userInfo: nil)))
                    }
                }
            }
        })
    }
    
    // MARK: Array responses
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set,ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response array (of type Mappable) and any error produced while making the request
    
    - returns: The request.
    */
    public func responseArray<T:EVObject>(encoding: NSStringEncoding? = nil, completionHandler: (Alamofire.Result<[T], NSError>) -> Void) -> Self {
        return responseArray(encoding: encoding) { (request, response, data: Alamofire.Result<[T], NSError>) -> Void in
            completionHandler(data)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter queue: The queue on which the completion handler is dispatched.
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set,ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response array (of type Mappable), the raw response data, and any error produced making the request.
    
    - returns: The request.
    */
    public func responseArray<T:EVObject>(queue: dispatch_queue_t? = nil, encoding: NSStringEncoding? = nil, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[T], NSError>) -> Void) -> Self {
        return responseString(encoding: encoding, completionHandler: { (response) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(queue ?? dispatch_get_main_queue()) {
                    switch response.result {
                    case .Success(let json):
                        let parsedObject:[T]? = T.arrayFromJson(json)
                        completionHandler(self.request, self.response, Result.Success(parsedObject!))
                    case .Failure(let error):
                        completionHandler(self.request, self.response, Result.Failure(error ?? NSError(domain: "NaN", code: 1, userInfo: nil)))
                    }
                }
            }
            
        })
    }
}