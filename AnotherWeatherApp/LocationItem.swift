//
//  LocationItem.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 19/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

import Foundation


protocol LocationItemDelegate: class {
    
    func weatherWasUpdated(for item: LocationItem)
}


final class LocationItem: NSCoding {
    let location: Location
    var weather: WeatherCondition?
    
    weak var delegate: LocationItemDelegate?
    
    init(location: Location, weather: WeatherCondition? = nil) {
        self.location = location
        self.weather = weather
    }
    
    func updateWeatherCondition() {
        ApixuAPI.getCurrentWeather(for: location) { success, weatherResponse in
            if success, let weatherResponse = weatherResponse {
                let weatherCondition = WeatherCondition(
                    summary: weatherResponse.condition,
                    windSpeed: weatherResponse.windSpeed,
                    windDirection: weatherResponse.windDirection,
                    temperature: weatherResponse.temperature)
                self.weather = weatherCondition
    
                self.delegate?.weatherWasUpdated(for: self)
            }
        }
    }
    
    // NSCoding
    
    private enum CodingKeys: String {
        case location
        case weather
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: CodingKeys.location.rawValue)
        aCoder.encode(weather, forKey: CodingKeys.weather.rawValue)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard let location = aDecoder.decodeObject(
            forKey: CodingKeys.location.rawValue) as? Location else {
            return nil
        }
        guard let weather = aDecoder.decodeObject(
            forKey: CodingKeys.weather.rawValue) as? WeatherCondition else {
            return nil
        }
        
        self.init(location: location, weather: weather)
    }
}
