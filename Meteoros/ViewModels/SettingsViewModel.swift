//
//  SettingsViewModel.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var appSettings: AppSettings
    
    private let settingsKey = "appSettings"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            appSettings = decoded
        } else {
            appSettings = AppSettings()
        }
    }
    
    // MARK: - Save Settings
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(appSettings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    // MARK: - Update Temperature Unit
    func updateTemperatureUnit(_ unit: TemperatureUnit) {
        appSettings.temperatureUnit = unit
        saveSettings()
    }
    
    // MARK: - Update Wind Speed Unit
    func updateWindSpeedUnit(_ unit: WindSpeedUnit) {
        appSettings.windSpeedUnit = unit
        saveSettings()
    }
    
    // MARK: - Update Notification Settings
    func updateNotificationSettings(_ settings: NotificationSettings) {
        appSettings.notificationSettings = settings
        saveSettings()
    }
    
    // MARK: - Toggle Challenges
    func toggleChallenges(_ enabled: Bool) {
        appSettings.enableChallenges = enabled
        saveSettings()
    }
    
    // MARK: - Reset All Settings
    func resetAllSettings() {
        appSettings = AppSettings()
        saveSettings()
    }
    
    // MARK: - Delete Account Data
    func deleteAccountData() {
        // Remove all saved data
        UserDefaults.standard.removeObject(forKey: settingsKey)
        UserDefaults.standard.removeObject(forKey: "savedLocations")
        UserDefaults.standard.removeObject(forKey: "weatherChallenges")
        UserDefaults.standard.removeObject(forKey: "totalPoints")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "lastSearchedCity")
        
        // Reset to default settings
        appSettings = AppSettings()
    }
    
    // MARK: - Convert Wind Speed
    func convertWindSpeed(_ speed: Double, from: WindSpeedUnit, to: WindSpeedUnit) -> Double {
        // Convert to m/s first
        var mps: Double
        switch from {
        case .metersPerSecond:
            mps = speed
        case .kilometersPerHour:
            mps = speed / 3.6
        case .milesPerHour:
            mps = speed / 2.237
        }
        
        // Convert from m/s to target unit
        switch to {
        case .metersPerSecond:
            return mps
        case .kilometersPerHour:
            return mps * 3.6
        case .milesPerHour:
            return mps * 2.237
        }
    }
}

