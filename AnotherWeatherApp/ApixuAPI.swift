//
//  ApixuAPI.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 20/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation

struct ApixuAPI {
    
    private static let baseUrl = "https://api.apixu.com/v1/current.json"
    private static let apiKey = "af6d9b9891ce410c868190219181705"
    
    static func getCurrentWeather(
            for location: LocationItem, completionHandler: @escaping (Bool) -> Void) {
        
        HTTPClient.get(from: buildUrl(given: location)) { (json, error) in
            if error == nil {
                completionHandler(true)
            }
        }
    }
    
    private static func buildUrl(given location: LocationItem) -> URL {
        return URL(string: "\(ApixuAPI.baseUrl)?key=\(ApixuAPI.apiKey)&q=\(location.latitude)," +
            "\(location.longitude)")!
    }
}
