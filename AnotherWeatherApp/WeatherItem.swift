//
//  WeatherItem.swift
//  AnotherWeatherApp
//
//  Created by João Carreira on 19/05/2018.
//  Copyright © 2018 João Carreira. All rights reserved.
//

final class WeatherItem {
    let location: LocationItem
    let weather: WeatherCondition?
    
    init(location: LocationItem, weather: WeatherCondition? = nil) {
        self.location = location
        self.weather = weather
    }
}


struct WeatherCondition {
    let summary: String
    let windSpeed: Int
    let windDirection: String
    let temperature: Int
}
