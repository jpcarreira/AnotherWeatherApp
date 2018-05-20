//
//  WeatherItem.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 19/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

protocol WeatherItemDelegate: class {
    
    func weatherWasUpdated(for item: WeatherItem)
}


final class WeatherItem {
    let location: LocationItem
    var weather: WeatherCondition?
    
    weak var delegate: WeatherItemDelegate?
    
    init(location: LocationItem, weather: WeatherCondition? = nil) {
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
}


struct WeatherCondition {
    let summary: String
    let windSpeed: Double
    let windDirection: String
    let temperature: Int
}
