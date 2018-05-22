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
            for location: Location, completionHandler: @escaping (Bool, WeatherResponse?) -> Void) {
        
        HTTPClient.get(from: buildUrl(given: location)) { (json, error) in
            if error == nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                    if let string = String(data: data, encoding: String.Encoding.utf8)?.data(using: .utf8) {
                        let weather = try JSONDecoder().decode(WeatherResponse.self, from: string)
                        completionHandler(true, weather)
                    }
                } catch {
                    completionHandler(false, nil)
                }
            }
        }
    }
    
    private static func buildUrl(given location: Location) -> URL {
        return URL(string: "\(ApixuAPI.baseUrl)?key=\(ApixuAPI.apiKey)&q=\(location.latitude)," +
            "\(location.longitude)")!
    }
}


struct WeatherResponse: Decodable {
    let temperature: Double
    let condition: String
    let windSpeed: Double
    let windDirection: String
    
    enum CodingKeys: String, CodingKey {
        case current
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case condition = "condition"
        case windSpeed = "wind_kph"
        case windDirection = "wind_dir"
    }
    
    enum ConditionCodingKeys: String, CodingKey {
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .current)
        
        temperature = try data.decode(Double.self, forKey: .temperature)
        let conditionContainer = try data.nestedContainer(
            keyedBy: ConditionCodingKeys.self, forKey: .condition)
        condition = try conditionContainer.decode(String.self, forKey: .text)
        windSpeed = try data.decode(Double.self, forKey: .windSpeed)
        windDirection = try data.decode(String.self, forKey: .windDirection)
    }
}
