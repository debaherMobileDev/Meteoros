//
//  NotificationService.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        checkAuthorizationStatus()
    }
    
    // MARK: - Request Authorization
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                self.authorizationStatus = granted ? .authorized : .denied
            }
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }
    
    // MARK: - Check Authorization Status
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // MARK: - Schedule Morning Weather Notification
    func scheduleMorningWeather(at time: Date, weather: WeatherResponse?) {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning! ☀️"
        
        if let weather = weather {
            let temp = Int(weather.main.temp.rounded())
            let description = weather.weather.first?.description.capitalized ?? "Unknown"
            content.body = "Today's weather: \(description), \(temp)°. Have a great day!"
        } else {
            content.body = "Check today's weather forecast!"
        }
        
        content.sound = .default
        content.categoryIdentifier = "MORNING_WEATHER"
        
        // Create date components for the trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "morningWeather", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling morning weather notification: \(error)")
            }
        }
    }
    
    // MARK: - Schedule Extreme Weather Alert
    func scheduleExtremeWeatherAlert(weather: WeatherResponse) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Extreme Weather Alert"
        
        let condition = weather.weather.first?.main ?? "Unknown"
        let temp = Int(weather.main.temp.rounded())
        
        content.body = "Extreme weather detected: \(condition), \(temp)°. Stay safe!"
        content.sound = .defaultCritical
        content.categoryIdentifier = "EXTREME_WEATHER"
        
        // Trigger immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling extreme weather alert: \(error)")
            }
        }
    }
    
    // MARK: - Schedule Daily Forecast
    func scheduleDailyForecast(at time: Date, forecast: ForecastResponse?) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Weather Forecast 🌤"
        
        if let forecast = forecast, let tomorrow = forecast.list.first {
            let temp = Int(tomorrow.main.temp.rounded())
            let description = tomorrow.weather.first?.description.capitalized ?? "Unknown"
            content.body = "Tomorrow: \(description), \(temp)°"
        } else {
            content.body = "Check tomorrow's forecast!"
        }
        
        content.sound = .default
        content.categoryIdentifier = "DAILY_FORECAST"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyForecast", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily forecast notification: \(error)")
            }
        }
    }
    
    // MARK: - Challenge Notification
    func scheduleChallenge(challenge: WeatherChallenge) {
        let content = UNMutableNotificationContent()
        content.title = "🎮 New Weather Challenge!"
        content.body = challenge.title
        content.sound = .default
        content.categoryIdentifier = "WEATHER_CHALLENGE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: challenge.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling challenge notification: \(error)")
            }
        }
    }
    
    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Cancel Specific Notification
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        completionHandler()
    }
}

