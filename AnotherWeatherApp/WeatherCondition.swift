//
//  WeatherCondition.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 22/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation

class WeatherCondition: NSObject, NSCoding {
    let summary: String
    let windSpeed: Double
    let windDirection: String
    let temperature: Double
    
    init(summary: String, windSpeed: Double, windDirection: String, temperature: Double) {
        self.summary = summary
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.temperature = temperature
    }
    
    // NSCoding
    
    private enum CodingKeys: String {
        case summary
        case windSpeed
        case windDirection
        case temperature
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(summary, forKey: CodingKeys.summary.rawValue)
        aCoder.encode(windSpeed, forKey: CodingKeys.windSpeed.rawValue)
        aCoder.encode(windDirection, forKey: CodingKeys.windDirection.rawValue)
        aCoder.encode(temperature, forKey: CodingKeys.temperature.rawValue)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let summary = aDecoder.decodeObject(
                forKey: CodingKeys.summary.rawValue) as? String else {
                    return nil
        }
        let windSpeed = aDecoder.decodeDouble(forKey: CodingKeys.windSpeed.rawValue)
        guard
            let windDirection = aDecoder.decodeObject(
                forKey: CodingKeys.windDirection.rawValue) as? String else {
                    return nil
        }
        let temperature = aDecoder.decodeDouble(forKey: CodingKeys.temperature.rawValue)
        
        self.init(
            summary: summary,
            windSpeed: windSpeed,
            windDirection: windDirection,
            temperature: temperature)
    }
}
