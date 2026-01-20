//
//  WeatherNotesView.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct WeatherNotesView: View {
    @StateObject private var viewModel = WeatherNotesViewModel()
    @State private var showingAddNote = false
    
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
                
                if viewModel.notes.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "note.text")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("No Weather Notes Yet")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Start tracking your daily weather observations")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            showingAddNote = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add First Note")
                            }
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "01A2FF"))
                            )
                        }
                        .padding(.top)
                    }
                } else {
                    // Notes list
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.notes) { note in
                                NavigationLink(destination: NoteDetailView(note: note, viewModel: viewModel)) {
                                    NoteCard(note: note)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Weather Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddNote = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "01A2FF"))
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Note Card
struct NoteCard: View {
    let note: WeatherNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color(hex: "01A2FF"))
                        Text(formatDate(note.date))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(Color(hex: "01A2FF"))
                        Text(note.cityName)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                Spacer()
                
                if let emoji = note.emoji {
                    Text(emoji)
                        .font(.system(size: 40))
                }
            }
            
            // Temperature and condition
            if let temp = note.temperature, let condition = note.weatherCondition {
                HStack {
                    Text("\(Int(temp.rounded()))°")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "01A2FF"))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(condition)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Note text
            Text(note.text)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Add Note View
struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WeatherNotesViewModel
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    @State private var noteText = ""
    @State private var selectedEmoji = "☀️"
    
    let emojis = ["☀️", "⛅️", "☁️", "🌧️", "⛈️", "🌩️", "❄️", "🌨️", "🌫️", "💨", "🌈", "🌡️"]
    
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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Current weather info
                        if let weather = weatherViewModel.currentWeather {
                            VStack(spacing: 10) {
                                Text(weather.name)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("\(Int(weather.main.temp.rounded()))°")
                                            .font(.system(size: 36, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(hex: "01A2FF"))
                                        
                                        Text(weather.weather.first?.description.capitalized ?? "")
                                            .font(.system(size: 14, weight: .regular, design: .rounded))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        
                        // Emoji picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Emoji")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                                ForEach(emojis, id: \.self) { emoji in
                                    Button(action: {
                                        selectedEmoji = emoji
                                    }) {
                                        Text(emoji)
                                            .font(.system(size: 35))
                                            .frame(width: 55, height: 55)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(selectedEmoji == emoji ? Color(hex: "01A2FF").opacity(0.3) : Color.white.opacity(0.1))
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedEmoji == emoji ? Color(hex: "01A2FF") : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                        
                        // Note text field
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Note")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                                
                                TextEditor(text: $noteText)
                                    .frame(height: 150)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.clear)
                                
                                if noteText.isEmpty {
                                    Text("Write your weather observations...")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding()
                                        .padding(.top, 8)
                                        .allowsHitTesting(false)
                                }
                            }
                            .frame(height: 150)
                        }
                        
                        // Save button
                        Button(action: saveNote) {
                            Text("Save Note")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(noteText.isEmpty ? Color.gray : Color(hex: "01A2FF"))
                                )
                        }
                        .disabled(noteText.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            if !weatherViewModel.currentCityName.isEmpty {
                Task {
                    await weatherViewModel.fetchWeatherForCity(weatherViewModel.currentCityName, units: .celsius)
                }
            }
        }
    }
    
    private func saveNote() {
        let note = WeatherNote(
            text: noteText,
            cityName: weatherViewModel.currentWeather?.name ?? weatherViewModel.currentCityName,
            temperature: weatherViewModel.currentWeather?.main.temp,
            weatherCondition: weatherViewModel.currentWeather?.weather.first?.description,
            emoji: selectedEmoji
        )
        
        viewModel.addNote(note)
        dismiss()
    }
}

// MARK: - Note Detail View
struct NoteDetailView: View {
    let note: WeatherNote
    @ObservedObject var viewModel: WeatherNotesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Emoji
                    if let emoji = note.emoji {
                        HStack {
                            Spacer()
                            Text(emoji)
                                .font(.system(size: 80))
                            Spacer()
                        }
                    }
                    
                    // Date and location
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "01A2FF"))
                            Text(formatDate(note.date))
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(hex: "01A2FF"))
                            Text(note.cityName)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Weather info
                    if let temp = note.temperature, let condition = note.weatherCondition {
                        HStack(spacing: 15) {
                            Text("\(Int(temp.rounded()))°")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "01A2FF"))
                            
                            Text(condition.capitalized)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    // Note text
                    Text(note.text)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .lineSpacing(6)
                    
                    Spacer()
                    
                    // Delete button
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Note")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.7))
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy 'at' HH:mm"
        return formatter.string(from: date)
    }
}

struct WeatherNotesView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNotesView()
    }
}

