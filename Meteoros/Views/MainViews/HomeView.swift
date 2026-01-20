//
//  HomeView.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var notesViewModel = WeatherNotesViewModel()
    @State private var showingSettings = false
    @State private var showingForecastDetail = false
    @State private var showingCitySearch = false
    @State private var showingNotes = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic Background
                if let weatherId = weatherViewModel.currentWeather?.weather.first?.weatherId {
                    let colors = WeatherService.shared.getWeatherBackground(for: weatherId)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: colors[0]),
                            Color(hex: colors[1])
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 1.0), value: weatherId)
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "090F1E"),
                            Color(hex: "1A2339")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Search Button
                        Button(action: {
                            showingCitySearch = true
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(hex: "01A2FF"))
                                Text(weatherViewModel.currentCityName.isEmpty ? "Search city..." : weatherViewModel.currentCityName)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                            )
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Current Weather Card
                        if let weather = weatherViewModel.currentWeather {
                            CurrentWeatherCard(weather: weather, unit: settingsViewModel.appSettings.temperatureUnit)
                                .padding(.horizontal)
                        } else if weatherViewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                                .padding()
                        } else {
                            EmptyWeatherView()
                                .padding()
                        }
                        
                        // Error message
                        if let error = weatherViewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                )
                                .padding(.horizontal)
                        }
                        
                        // Weather Details
                        if let weather = weatherViewModel.currentWeather {
                            WeatherDetailsCard(weather: weather, windSpeedUnit: settingsViewModel.appSettings.windSpeedUnit)
                                .padding(.horizontal)
                        }
                        
                        // Forecast Chart
                        if let forecast = weatherViewModel.forecast {
                            ForecastChartCard(forecast: forecast, unit: settingsViewModel.appSettings.temperatureUnit)
                                .padding(.horizontal)
                                .onTapGesture {
                                    showingForecastDetail = true
                                }
                        }
                        
                        // Challenges Section
                        if settingsViewModel.appSettings.enableChallenges {
                            ChallengesCard(
                                challenges: weatherViewModel.challenges,
                                totalPoints: weatherViewModel.totalPoints
                            )
                            .padding(.horizontal)
                        }
                        
                        // Weather Notes Section
                        WeatherNotesCard(notesCount: notesViewModel.notes.count) {
                            showingNotes = true
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await weatherViewModel.fetchWeatherForCity(weatherViewModel.currentCityName, units: settingsViewModel.appSettings.temperatureUnit)
                }
            }
            .navigationTitle("Meteoros")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingNotes = true
                    }) {
                        Image(systemName: "note.text")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingForecastDetail) {
                if let forecast = weatherViewModel.forecast {
                    ForecastDetailView(forecast: forecast, unit: settingsViewModel.appSettings.temperatureUnit)
                }
            }
            .sheet(isPresented: $showingCitySearch) {
                CitySearchView(weatherViewModel: weatherViewModel, settingsViewModel: settingsViewModel, isPresented: $showingCitySearch)
            }
            .sheet(isPresented: $showingNotes) {
                WeatherNotesView()
            }
        }
        .onAppear {
            if !weatherViewModel.currentCityName.isEmpty {
                Task {
                    await weatherViewModel.fetchWeatherForCity(weatherViewModel.currentCityName, units: settingsViewModel.appSettings.temperatureUnit)
                }
            }
        }
    }
}

// MARK: - Current Weather Card
struct CurrentWeatherCard: View {
    let weather: WeatherResponse
    let unit: TemperatureUnit
    
    var body: some View {
        VStack(spacing: 15) {
            // Location
            Text(weather.name)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            // Weather Icon
            if let weatherId = weather.weather.first?.weatherId {
                Image(systemName: WeatherService.shared.getWeatherIcon(for: weatherId))
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
            }
            
            // Temperature
            Text("\(Int(weather.main.temp.rounded()))°")
                .font(.system(size: 72, weight: .thin, design: .rounded))
                .foregroundColor(.white)
            
            // Description
            if let description = weather.weather.first?.description {
                Text(description.capitalized)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            // Feels Like
            Text("Feels like \(Int(weather.main.feelsLike.rounded()))°")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
    }
}

// MARK: - Weather Details Card
struct WeatherDetailsCard: View {
    let weather: WeatherResponse
    let windSpeedUnit: WindSpeedUnit
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                WeatherDetailItem(
                    icon: "humidity.fill",
                    title: "Humidity",
                    value: "\(weather.main.humidity)%"
                )
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                WeatherDetailItem(
                    icon: "wind",
                    title: "Wind",
                    value: String(format: "%.1f %@", weather.wind?.speed ?? 0, windSpeedUnit.rawValue)
                )
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            HStack(spacing: 0) {
                WeatherDetailItem(
                    icon: "gauge.medium",
                    title: "Pressure",
                    value: "\(weather.main.pressure) hPa"
                )
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                WeatherDetailItem(
                    icon: "eye.fill",
                    title: "Visibility",
                    value: String(format: "%.1f km", Double(weather.visibility ?? 0) / 1000)
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "01A2FF"))
            
            Text(title)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// MARK: - Forecast Chart Card
struct ForecastChartCard: View {
    let forecast: ForecastResponse
    let unit: TemperatureUnit
    
    private var chartData: [ForecastItem] {
        Array(forecast.list.prefix(8))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("5-Day Forecast")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Simple forecast list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(chartData) { item in
                        VStack(spacing: 8) {
                            Text(formatTime(Date(timeIntervalSince1970: item.dt)))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            if let weatherId = item.weather.first?.weatherId {
                                Image(systemName: WeatherService.shared.getWeatherIcon(for: weatherId))
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "01A2FF"))
                                    .symbolRenderingMode(.hierarchical)
                            }
                            
                            Text("\(Int(item.main.temp.rounded()))°")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(width: 70)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
            }
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

// MARK: - Challenges Card
struct ChallengesCard: View {
    let challenges: [WeatherChallenge]
    let totalPoints: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Weather Challenges")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(totalPoints)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            
            ForEach(challenges.prefix(3)) { challenge in
                ChallengeRow(challenge: challenge)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
        )
    }
}

struct ChallengeRow: View {
    let challenge: WeatherChallenge
    
    var body: some View {
        HStack {
            Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(challenge.isCompleted ? .green : .white.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(challenge.description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text("+\(challenge.points)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "01A2FF"))
        }
    }
}

// MARK: - Empty Weather View
struct EmptyWeatherView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.5))
            
            Text("No city selected")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Tap the search button to find a city")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
    }
}

// MARK: - City Search View
// MARK: - Weather Notes Card
struct WeatherNotesCard: View {
    let notesCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "note.text")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "01A2FF"))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weather Notes")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("\(notesCount) \(notesCount == 1 ? "note" : "notes") saved")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text("Track your daily weather observations")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }
}

struct CitySearchView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "090F1E"),
                        Color(hex: "1A2339")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField("Enter city name", text: $searchText)
                            .foregroundColor(.white)
                            .autocapitalization(.words)
                            .submitLabel(.search)
                            .onSubmit {
                                searchCity()
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                    )
                    .padding(.horizontal)
                    
                    // Popular cities
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Popular Cities")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(["Moscow", "London", "New York", "Tokyo", "Paris", "Berlin", "Sydney", "Dubai"], id: \.self) { city in
                                    Button(action: {
                                        searchText = city
                                        searchCity()
                                    }) {
                                        HStack {
                                            Image(systemName: "location.fill")
                                                .foregroundColor(Color(hex: "01A2FF"))
                                            Text(city)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.1))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(Color(hex: "01A2FF"))
                }
            }
        }
    }
    
    private func searchCity() {
        guard !searchText.isEmpty else { return }
        
        Task {
            await weatherViewModel.fetchWeatherForCity(searchText, units: settingsViewModel.appSettings.temperatureUnit)
            isPresented = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

