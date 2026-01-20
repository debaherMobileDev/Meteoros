//
//  WeatherViewModel.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentCityName: String = ""
    @Published var savedLocations: [SavedLocation] = []
    @Published var challenges: [WeatherChallenge] = []
    @Published var totalPoints: Int = 0
    
    private let weatherService = WeatherService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSavedLocations()
        loadChallenges()
        loadTotalPoints()
        
        // Load default city
        if let savedCity = UserDefaults.standard.string(forKey: "lastSearchedCity"), !savedCity.isEmpty {
            currentCityName = savedCity
        } else {
            currentCityName = "Moscow" // Default city
        }
    }
    
    // MARK: - Fetch Weather
    func fetchWeatherForCity(_ cityName: String, units: TemperatureUnit = .celsius) async {
        guard !cityName.isEmpty else {
            errorMessage = "Please enter a city name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeatherByCity(cityName: cityName, units: units)
            currentWeather = weather
            currentCityName = weather.name
            
            // Save last searched city
            UserDefaults.standard.set(weather.name, forKey: "lastSearchedCity")
            
            // Update challenges
            updateChallenges(with: weather)
            
            // Fetch forecast
            await fetchForecastForCity(weather.name, units: units)
            
        } catch {
            errorMessage = "City not found. Please try again."
        }
        
        isLoading = false
    }
    
    func fetchForecastForCity(_ cityName: String, units: TemperatureUnit = .celsius) async {
        do {
            // First get coordinates from city name
            let weather = try await weatherService.fetchWeatherByCity(cityName: cityName, units: units)
            
            if let coord = weather.coord {
                let forecastData = try await weatherService.fetchForecast(
                    latitude: coord.lat,
                    longitude: coord.lon,
                    units: units
                )
                forecast = forecastData
            }
        } catch {
            // Silently fail for forecast
        }
    }
    
    // MARK: - Saved Locations
    func addLocation(_ location: SavedLocation) {
        savedLocations.append(location)
        saveSavedLocations()
    }
    
    func removeLocation(_ location: SavedLocation) {
        savedLocations.removeAll { $0.id == location.id }
        saveSavedLocations()
    }
    
    private func saveSavedLocations() {
        if let encoded = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(encoded, forKey: "savedLocations")
        }
    }
    
    private func loadSavedLocations() {
        if let data = UserDefaults.standard.data(forKey: "savedLocations"),
           let decoded = try? JSONDecoder().decode([SavedLocation].self, from: data) {
            savedLocations = decoded
        }
    }
    
    // MARK: - Weather Challenges
    private func generateChallenges() -> [WeatherChallenge] {
        return [
            WeatherChallenge(
                title: "Rainy Day Ready",
                description: "Don't forget your umbrella on a rainy day!",
                condition: "rain",
                points: 15
            ),
            WeatherChallenge(
                title: "Sun Seeker",
                description: "Enjoy a sunny day outdoors",
                condition: "clear",
                points: 10
            ),
            WeatherChallenge(
                title: "Snow Explorer",
                description: "Experience a snowy day",
                condition: "snow",
                points: 20
            ),
            WeatherChallenge(
                title: "Weather Warrior",
                description: "Check the weather 7 days in a row",
                condition: "streak",
                points: 25
            ),
            WeatherChallenge(
                title: "Hot Day Hydration",
                description: "Stay hydrated when temperature is above 30°C",
                condition: "hot",
                points: 15
            ),
            WeatherChallenge(
                title: "Cold Day Cozy",
                description: "Stay warm when temperature is below 0°C",
                condition: "cold",
                points: 15
            )
        ]
    }
    
    private func updateChallenges(with weather: WeatherResponse) {
        guard let weatherCondition = weather.weather.first?.main.lowercased() else { return }
        
        for (index, challenge) in challenges.enumerated() {
            if !challenge.isCompleted {
                var shouldComplete = false
                
                switch challenge.condition {
                case "rain":
                    shouldComplete = weatherCondition.contains("rain")
                case "clear":
                    shouldComplete = weatherCondition == "clear"
                case "snow":
                    shouldComplete = weatherCondition.contains("snow")
                case "hot":
                    shouldComplete = weather.main.temp > 30
                case "cold":
                    shouldComplete = weather.main.temp < 0
                default:
                    break
                }
                
                if shouldComplete {
                    challenges[index] = WeatherChallenge(
                        id: challenge.id,
                        title: challenge.title,
                        description: challenge.description,
                        condition: challenge.condition,
                        isCompleted: true,
                        points: challenge.points
                    )
                    totalPoints += challenge.points
                    saveTotalPoints()
                    NotificationService.shared.scheduleChallenge(challenge: challenges[index])
                }
            }
        }
        saveChallenges()
    }
    
    private func loadChallenges() {
        if let data = UserDefaults.standard.data(forKey: "weatherChallenges"),
           let decoded = try? JSONDecoder().decode([WeatherChallenge].self, from: data) {
            challenges = decoded
        } else {
            challenges = generateChallenges()
            saveChallenges()
        }
    }
    
    private func saveChallenges() {
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: "weatherChallenges")
        }
    }
    
    private func loadTotalPoints() {
        totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
    }
    
    private func saveTotalPoints() {
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
    }
    
    func resetChallenges() {
        challenges = generateChallenges()
        saveChallenges()
    }
}

