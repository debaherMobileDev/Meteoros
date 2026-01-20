//
//  WeatherNotesViewModel.swift
//  Meteoros
//
//  Created on 2026.
//

import Foundation

class WeatherNotesViewModel: ObservableObject {
    @Published var notes: [WeatherNote] = []
    
    private let notesKey = "weatherNotes"
    
    init() {
        loadNotes()
    }
    
    // MARK: - Load Notes
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([WeatherNote].self, from: data) {
            notes = decoded.sorted { $0.date > $1.date }
        }
    }
    
    // MARK: - Save Notes
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    // MARK: - Add Note
    func addNote(_ note: WeatherNote) {
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    // MARK: - Update Note
    func updateNote(_ note: WeatherNote) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    // MARK: - Delete Note
    func deleteNote(_ note: WeatherNote) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    // MARK: - Delete Note at Index
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    // MARK: - Get Notes for Date
    func getNotes(for date: Date) -> [WeatherNote] {
        let calendar = Calendar.current
        return notes.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    // MARK: - Get Today's Notes
    func getTodayNotes() -> [WeatherNote] {
        getNotes(for: Date())
    }
    
    // MARK: - Clear All Notes
    func clearAllNotes() {
        notes.removeAll()
        saveNotes()
    }
}

