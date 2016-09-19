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

extension DataRequest {
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set,ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request
    
    - returns: The request.
    */
    public func responseObject<T:EVObject>(_ encoding: String.Encoding? = nil, completionHandler: @escaping (Result<T>) -> Void) -> Self {
        return responseObject(encoding: encoding) { (request, response, data: Alamofire.Result<T>) -> Void in
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
    public func responseObject<T:EVObject>(_ queue: DispatchQueue? = nil, encoding: String.Encoding? = nil, completionHandler: @escaping (URLRequest?, HTTPURLResponse?, Result<T>) -> Void) -> Self {
        return responseString(encoding: encoding, completionHandler: { (response) -> Void in
            DispatchQueue.global().async {
                (queue ?? DispatchQueue.main).async {
                    switch response.result {
                    case .success(let json):
                        let t = T()
                        let jsonDict = EVReflection.dictionaryFromJson(json)
                        let _ = EVReflection.setPropertiesfromDictionary(jsonDict, anyObject: t)
                        completionHandler(self.request, self.response, Result.success(t))
                    case .failure(let error):
                        completionHandler(self.request, self.response, Result.failure(error))
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
    public func responseArray<T:EVObject>(_ encoding: String.Encoding? = nil, completionHandler: @escaping (Alamofire.Result<[T]>) -> Void) -> Self {
        return responseArray(encoding: encoding) { (request, response, data: Alamofire.Result<[T]>) -> Void in
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
    public func responseArray<T:EVObject>(_ queue: DispatchQueue? = nil, encoding: String.Encoding? = nil, completionHandler: @escaping (URLRequest?, HTTPURLResponse?, Result<[T]>) -> Void) -> Self {
        return responseString(encoding: encoding, completionHandler: { (response) -> Void in
            DispatchQueue.global().async {
                (queue ?? DispatchQueue.main).async {
                    switch response.result {
                    case .success(let json):
                        let parsedObject:[T] = T.arrayFromJson(json)
                        completionHandler(self.request, self.response, Result.success(parsedObject))                        
                    case .failure(let error):
                        completionHandler(self.request, self.response, Result.failure(error))
                    }
                }
            }
            
        })
    }
}
