//
//  WeatherContainer.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let clouds: Clouds
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case name, weather, main, clouds, wind
    }
}

struct Weather: Decodable {
    let id: Double
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}

struct Clouds: Decodable {
    let all: Double
}

struct Wind: Decodable {
    let speed: Double
}

extension WeatherResult {
    func getTemp() -> String {
        return "\(main.temp.getFahrenheit().rounded(toPlaces: 2))"
    }
    
    func getWeatherIconURL() -> URL? {
        guard let icon = weather.first?.icon,
            let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") else {
            return .none
        }
        return url
    }
    
    func getWind() -> String {
        return "\(wind.speed) mph"
    }
    
    func getCloud() -> String {
        return "\(clouds.all) \(clouds.all == 1 ? "cloud" : "clouds")"
    }
}




