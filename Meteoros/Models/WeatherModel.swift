//
//  WeatherModel.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation
import CoreLocation

// MARK: - Weather Response Models
struct WeatherResponse: Codable {
    let coord: Coordinates?
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let dt: TimeInterval
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String
    let cod: Int?
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable, Identifiable {
    var id: Int { self.weatherId }
    let weatherId: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case main
        case description
        case icon
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Snow: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}

// MARK: - Forecast Response
struct ForecastResponse: Codable {
    let cod: String
    let message: Int?
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let snow: Snow?
    let sys: ForecastSys?
    let dtTxt: String
    
    var id: TimeInterval { dt }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case snow
        case sys
        case dtTxt = "dt_txt"
    }
}

struct ForecastSys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int?
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

// MARK: - Location Model
struct SavedLocation: Identifiable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Weather Challenge Model
struct WeatherChallenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let condition: String
    let isCompleted: Bool
    let points: Int
    
    init(id: UUID = UUID(), title: String, description: String, condition: String, isCompleted: Bool = false, points: Int = 10) {
        self.id = id
        self.title = title
        self.description = description
        self.condition = condition
        self.isCompleted = isCompleted
        self.points = points
    }
}

// MARK: - Weather Note Model
struct WeatherNote: Identifiable, Codable {
    let id: UUID
    let date: Date
    var text: String
    var cityName: String
    var temperature: Double?
    var weatherCondition: String?
    var emoji: String?
    
    init(id: UUID = UUID(), date: Date = Date(), text: String, cityName: String, temperature: Double? = nil, weatherCondition: String? = nil, emoji: String? = nil) {
        self.id = id
        self.date = date
        self.text = text
        self.cityName = cityName
        self.temperature = temperature
        self.weatherCondition = weatherCondition
        self.emoji = emoji
    }
}

