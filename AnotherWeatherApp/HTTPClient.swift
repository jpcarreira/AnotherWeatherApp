//
//  APIClient.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 19/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation


struct HTTPClient {
    
    static func get(
            from url: URL,
            completionHandler: @escaping (AnyObject?, HTTPError?) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let jsonData = data {
                            do {
                                let unserializedJson = try JSONSerialization.jsonObject(
                                    with: jsonData,
                                    options: JSONSerialization.ReadingOptions.mutableContainers)
                                if let parsedJsonDictionary =
                                    unserializedJson as? [String: AnyObject] {
                                        completionHandler(parsedJsonDictionary as AnyObject?, nil)
                                } else if let parsedJsonArray
                                    = unserializedJson as? Array<AnyObject> {
                                        completionHandler(parsedJsonArray as AnyObject?, nil)
                                }
                            } catch let error as NSError {
                                completionHandler(
                                    nil,
                                    HTTPError(
                                        errorCode: HTTPErrorCode.other,
                                        errorDetails: error.userInfo as
                                            Dictionary<NSObject, AnyObject>?))
                            }
                        }
                    } else {
                        completionHandler(
                            nil,
                            HTTPError(
                                errorCode: HTTPErrorCode(rawValue: httpResponse.statusCode)!, errorDetails: nil))
                    }
                }
            } else {
                completionHandler(
                    nil,
                    HTTPError(errorCode: HTTPErrorCode.noResponse,
                        errorDetails: error?._userInfo as! Dictionary<NSObject, AnyObject>?))
            }
        })
        
        dataTask.resume()
    }
}


struct HTTPError {
    let errorCode: HTTPErrorCode
    let errorDetails: Dictionary<NSObject, AnyObject>?
}


enum HTTPErrorCode: Int {
    case unauthorized = 401
    case notFound = 404
    case internalServerError = 500
    case other = 0
    case noResponse = -1
}
