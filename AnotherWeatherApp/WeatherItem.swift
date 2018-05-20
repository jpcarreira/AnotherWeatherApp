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
        ApixuAPI.getCurrentWeather(for: location) { success in
            if success {
                // TODO: fake data
                let weatherCondition = WeatherCondition(
                    summary: "good",
                    windSpeed: 10,
                    windDirection: "SE",
                    temperature: 14)
                self.weather = weatherCondition
                
                self.delegate?.weatherWasUpdated(for: self)
            }
        }
    }
}


struct WeatherCondition {
    let summary: String
    let windSpeed: Int
    let windDirection: String
    let temperature: Int
}
