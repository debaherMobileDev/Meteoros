//
//  ForecastDetailView.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct ForecastDetailView: View {
    @Environment(\.dismiss) var dismiss
    let forecast: ForecastResponse
    let unit: TemperatureUnit
    
    var groupedForecast: [Date: [ForecastItem]] {
        let calendar = Calendar.current
        return Dictionary(grouping: forecast.list) { item in
            calendar.startOfDay(for: Date(timeIntervalSince1970: item.dt))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "090F1E"),
                        Color(hex: "1A2339")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // City Info
                        VStack(spacing: 5) {
                            Text(forecast.city.name)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("\(forecast.city.country)")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top)
                        
                        // Temperature Chart
                        TemperatureChartView(items: forecast.list, unit: unit)
                            .padding(.horizontal)
                        
                        // Daily Forecast List
                        ForEach(groupedForecast.keys.sorted(), id: \.self) { date in
                            if let items = groupedForecast[date] {
                                DailyForecastSection(date: date, items: items, unit: unit)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Forecast Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
    }
}

// MARK: - Temperature Chart View
struct TemperatureChartView: View {
    let items: [ForecastItem]
    let unit: TemperatureUnit
    
    private var chartData: [ForecastItem] {
        Array(items.prefix(12))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Temperature Trend")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            // Temperature bars
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(chartData) { item in
                        VStack(spacing: 6) {
                            Text("\(Int(item.main.temp.rounded()))°")
                                .font(.caption2)
                                .foregroundColor(.white)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "01A2FF"))
                                .frame(width: 30, height: CGFloat(item.main.temp + 50))
                            
                            Text(formatTime(Date(timeIntervalSince1970: item.dt)))
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.vertical)
            }
            .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Daily Forecast Section
struct DailyForecastSection: View {
    let date: Date
    let items: [ForecastItem]
    let unit: TemperatureUnit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Date Header
            Text(formatDate(date))
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            // Hourly items
            VStack(spacing: 10) {
                ForEach(items) { item in
                    HourlyForecastRow(item: item, unit: unit)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Hourly Forecast Row
struct HourlyForecastRow: View {
    let item: ForecastItem
    let unit: TemperatureUnit
    
    var body: some View {
        HStack {
            // Time
            Text(formatTime(Date(timeIntervalSince1970: item.dt)))
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 60, alignment: .leading)
            
            // Weather Icon
            if let weatherId = item.weather.first?.weatherId {
                Image(systemName: WeatherService.shared.getWeatherIcon(for: weatherId))
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "01A2FF"))
                    .frame(width: 40)
                    .symbolRenderingMode(.hierarchical)
            }
            
            // Description
            if let description = item.weather.first?.description {
                Text(description.capitalized)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Temperature
            Text("\(Int(item.main.temp.rounded()))°")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            // Precipitation
            if let pop = item.pop, pop > 0 {
                HStack(spacing: 3) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 10))
                    Text("\(Int(pop * 100))%")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .foregroundColor(Color(hex: "01A2FF"))
            }
        }
        .padding(.vertical, 5)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ForecastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock forecast for preview
        let mockForecast = ForecastResponse(
            cod: "200",
            message: 0,
            cnt: 40,
            list: [],
            city: City(
                id: 1,
                name: "Sample City",
                coord: Coordinates(lon: 0, lat: 0),
                country: "US",
                population: 0,
                timezone: 0,
                sunrise: Date().timeIntervalSince1970,
                sunset: Date().timeIntervalSince1970
            )
        )
        
        ForecastDetailView(forecast: mockForecast, unit: .celsius)
    }
}

