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

    enum ErrorCode: Int {
        case noData = 1
    }
    
    internal static func newError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.alamofirejsontoobjects.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    public static func EVReflectionSerializer<T: EVObject>(_ keyPath: String?, mapToObject object: T? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.noData, failureReason: failureReason)
                return .failure(error)
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: Any?
            if let keyPath = keyPath , keyPath.isEmpty == false {
                JSONToMap = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                JSONToMap = result.value
            }

            if let object = object {
                let _ = EVReflection.setPropertiesfromDictionary(JSONToMap as? NSDictionary ?? NSDictionary(), anyObject: object)
                return .success(object)
            }
            
            let parsedObject = T(dictionary: JSONToMap as? NSDictionary ?? NSDictionary())
            return .success(parsedObject)
        }
    }

    @discardableResult
    public func responseObject<T: EVObject>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        
        let serializer = DataRequest.EVReflectionSerializer(keyPath, mapToObject: object)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    
    public static func EVReflectionArraySerializer<T: EVObject>(_ keyPath: String?, mapToObject object: T? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.noData, failureReason: failureReason)
                return .failure(error)
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: Any?
            if let keyPath = keyPath, keyPath.isEmpty == false {
                JSONToMap = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                JSONToMap = result.value
            }
            
            let parsedObject:[T] = ((JSONToMap as? NSArray) ?? NSArray() ).map { T(dictionary: ($0 as? NSDictionary ?? NSDictionary()))} as [T]
            
            //T.arrayFromJson(JSONToMap as? String)
            return .success(parsedObject)
        }
    }
    
    
    @discardableResult
    public func responseArray<T: EVObject>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        let serializer = DataRequest.EVReflectionArraySerializer(keyPath, mapToObject: object)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }
}
