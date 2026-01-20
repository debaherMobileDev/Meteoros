//
//  WeatherService.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation
import CoreLocation

class WeatherService {
    static let shared = WeatherService()
    
    // OpenWeatherMap API Key - You should replace this with your own key
    private let apiKey = "YOUR_API_KEY_HERE"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    private init() {}
    
    // MARK: - Fetch Current Weather
    func fetchCurrentWeather(latitude: Double, longitude: Double, units: TemperatureUnit = .celsius) async throws -> WeatherResponse {
        let urlString = "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
    
    // MARK: - Fetch 5-Day Forecast
    func fetchForecast(latitude: Double, longitude: Double, units: TemperatureUnit = .celsius) async throws -> ForecastResponse {
        let urlString = "\(baseURL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
            return forecastResponse
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
    
    // MARK: - Fetch Weather by City Name
    func fetchWeatherByCity(cityName: String, units: TemperatureUnit = .celsius) async throws -> WeatherResponse {
        let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "\(baseURL)/weather?q=\(encodedCity)&appid=\(apiKey)&units=\(units.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
    
    // MARK: - Weather Condition Helpers
    func getWeatherIcon(for weatherId: Int) -> String {
        switch weatherId {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801: return "cloud.sun.fill"
        case 802: return "cloud.fill"
        case 803...804: return "smoke.fill"
        default: return "cloud.fill"
        }
    }
    
    func getWeatherBackground(for weatherId: Int) -> [String] {
        switch weatherId {
        case 200...232: return ["#1A2339", "#090F1E"] // Thunderstorm
        case 300...321: return ["#1A2339", "#090F1E"] // Drizzle
        case 500...531: return ["#1A2339", "#090F1E"] // Rain
        case 600...622: return ["#B8C6DB", "#F5F7FA"] // Snow
        case 701...781: return ["#74859C", "#090F1E"] // Atmosphere
        case 800: return ["#56CCF2", "#2F80ED"] // Clear
        case 801...804: return ["#1A2339", "#56CCF2"] // Clouds
        default: return ["#1A2339", "#090F1E"]
        }
    }
    
    func isExtremeWeather(weatherId: Int, temp: Double, windSpeed: Double) -> Bool {
        // Thunderstorms
        if weatherId >= 200 && weatherId < 300 {
            return true
        }
        // Heavy rain
        if weatherId >= 500 && weatherId <= 531 {
            return true
        }
        // Snow
        if weatherId >= 600 && weatherId <= 622 {
            return true
        }
        // Extreme temperatures
        if temp < -10 || temp > 40 {
            return true
        }
        // High wind speed
        if windSpeed > 15 {
            return true
        }
        return false
    }
}

// MARK: - Weather Error
enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

