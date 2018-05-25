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
    var icon: String
    let windSpeed: Double
    let windDirection: String
    let temperature: Double
    
    init(
            summary: String, icon: String, windSpeed: Double, windDirection: String,
            temperature: Double) {
        self.summary = summary
        self.icon = WeatherCondition.iconOnly(iconUrl: icon)
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.temperature = temperature
    }
    
    private static func iconOnly(iconUrl: String) -> String {
        return String(String(iconUrl.suffix(7)).prefix(3))
    }
    
    // NSCoding
    
    private enum CodingKeys: String {
        case summary
        case icon
        case windSpeed
        case windDirection
        case temperature
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(summary, forKey: CodingKeys.summary.rawValue)
        aCoder.encode(icon, forKey: CodingKeys.icon.rawValue)
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
        guard
            let icon = aDecoder.decodeObject(
                forKey: CodingKeys.icon.rawValue) as? String else {
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
            icon: icon,
            windSpeed: windSpeed,
            windDirection: windDirection,
            temperature: temperature)
    }
}
