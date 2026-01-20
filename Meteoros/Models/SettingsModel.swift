//
//  SettingsModel.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation

// MARK: - Temperature Unit
enum TemperatureUnit: String, CaseIterable, Codable {
    case celsius = "metric"
    case fahrenheit = "imperial"
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
    
    var displayName: String {
        switch self {
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        }
    }
}

// MARK: - Wind Speed Unit
enum WindSpeedUnit: String, CaseIterable, Codable {
    case metersPerSecond = "m/s"
    case kilometersPerHour = "km/h"
    case milesPerHour = "mph"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Notification Settings
struct NotificationSettings: Codable {
    var morningWeather: Bool
    var extremeWeatherAlerts: Bool
    var dailyForecast: Bool
    var morningTime: Date
    var eveningTime: Date
    
    init(morningWeather: Bool = true,
         extremeWeatherAlerts: Bool = true,
         dailyForecast: Bool = true,
         morningTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
         eveningTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()) {
        self.morningWeather = morningWeather
        self.extremeWeatherAlerts = extremeWeatherAlerts
        self.dailyForecast = dailyForecast
        self.morningTime = morningTime
        self.eveningTime = eveningTime
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var temperatureUnit: TemperatureUnit
    var windSpeedUnit: WindSpeedUnit
    var notificationSettings: NotificationSettings
    var enableChallenges: Bool
    
    init(temperatureUnit: TemperatureUnit = .celsius,
         windSpeedUnit: WindSpeedUnit = .metersPerSecond,
         notificationSettings: NotificationSettings = NotificationSettings(),
         enableChallenges: Bool = true) {
        self.temperatureUnit = temperatureUnit
        self.windSpeedUnit = windSpeedUnit
        self.notificationSettings = notificationSettings
        self.enableChallenges = enableChallenges
    }
}

