//
//  AccountDeletionView.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct AccountDeletionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var settingsViewModel = SettingsViewModel()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @State private var confirmationText = ""
    @State private var showingDeleteConfirmation = false
    
    private let requiredText = "DELETE"
    
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
                    VStack(spacing: 30) {
                        // Warning Icon
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.red)
                            .padding(.top, 40)
                        
                        // Title
                        Text("Delete All Data")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        // Warning Message
                        VStack(alignment: .leading, spacing: 15) {
                            Text("This action will permanently delete:")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                DeletionItem(text: "All saved locations")
                                DeletionItem(text: "Weather challenges and points")
                                DeletionItem(text: "All app settings and preferences")
                                DeletionItem(text: "Notification preferences")
                                DeletionItem(text: "Onboarding completion status")
                            }
                            
                            Text("⚠️ This action cannot be undone!")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.2))
                        )
                        .padding(.horizontal)
                        
                        // Confirmation Input
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Type '\(requiredText)' to confirm")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextField("", text: $confirmationText)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                )
                                .foregroundColor(.white)
                                .autocapitalization(.allCharacters)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal)
                        
                        // Delete Button
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            Text("Delete All Data")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(confirmationText == requiredText ? Color.red : Color.gray)
                                )
                        }
                        .disabled(confirmationText != requiredText)
                        .padding(.horizontal)
                        
                        // Cancel Button
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(hex: "01A2FF"))
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Delete Data")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Final Confirmation", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    performDeletion()
                }
            } message: {
                Text("Are you absolutely sure you want to delete all your data? This action is permanent and cannot be undone.")
            }
        }
    }
    
    private func performDeletion() {
        // Delete all data
        settingsViewModel.deleteAccountData()
        
        // Reset onboarding
        hasCompletedOnboarding = false
        
        // Dismiss the view
        dismiss()
    }
}

struct DeletionItem: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 16))
            
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct AccountDeletionView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDeletionView()
    }
}

