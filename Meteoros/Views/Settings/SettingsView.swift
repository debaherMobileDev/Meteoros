//
//  SettingsView.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingAccountDeletion = false
    
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
                    VStack(spacing: 25) {
                        // Units Section
                        SettingsSection(title: "Units") {
                            VStack(spacing: 0) {
                                // Temperature Unit
                                HStack {
                                    Image(systemName: "thermometer.medium")
                                        .foregroundColor(Color(hex: "01A2FF"))
                                        .frame(width: 30)
                                    
                                    Text("Temperature")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Picker("Temperature", selection: $viewModel.appSettings.temperatureUnit) {
                                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                                            Text(unit.displayName).tag(unit)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accentColor(Color(hex: "01A2FF"))
                                }
                                .padding()
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                
                                // Wind Speed Unit
                                HStack {
                                    Image(systemName: "wind")
                                        .foregroundColor(Color(hex: "01A2FF"))
                                        .frame(width: 30)
                                    
                                    Text("Wind Speed")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Picker("Wind Speed", selection: $viewModel.appSettings.windSpeedUnit) {
                                        ForEach(WindSpeedUnit.allCases, id: \.self) { unit in
                                            Text(unit.displayName).tag(unit)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accentColor(Color(hex: "01A2FF"))
                                }
                                .padding()
                            }
                        }
                        
                        // Features Section
                        SettingsSection(title: "Features") {
                            Toggle(isOn: $viewModel.appSettings.enableChallenges) {
                                HStack {
                                    Image(systemName: "gamecontroller.fill")
                                        .foregroundColor(Color(hex: "01A2FF"))
                                        .frame(width: 30)
                                    
                                    Text("Weather Challenges")
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(Color(hex: "01A2FF"))
                            .padding()
                        }
                        
                        // About Section
                        SettingsSection(title: "About") {
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(Color(hex: "01A2FF"))
                                        .frame(width: 30)
                                    
                                    Text("Version")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("1.0.0")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding()
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                
                                HStack {
                                    Image(systemName: "building.2")
                                        .foregroundColor(Color(hex: "01A2FF"))
                                        .frame(width: 30)
                                    
                                    Text("Developer")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("Meteoros Team")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding()
                            }
                        }
                        
                        // Danger Zone
                        SettingsSection(title: "Danger Zone") {
                            VStack(spacing: 0) {
                                Button(action: {
                                    viewModel.resetAllSettings()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise")
                                            .foregroundColor(.orange)
                                            .frame(width: 30)
                                        
                                        Text("Reset Settings")
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                
                                Button(action: {
                                    showingAccountDeletion = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                            .frame(width: 30)
                                        
                                        Text("Delete All Data")
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.saveSettings()
                        dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(Color(hex: "01A2FF"))
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showingAccountDeletion) {
                AccountDeletionView()
            }
        }
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

