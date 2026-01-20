//
//  OnboardingPage1.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Icon/Logo
            Image(systemName: "cloud.sun.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(Color(hex: "01A2FF"))
                .padding(.bottom, 20)
            
            // Title
            Text("Welcome to Meteoros")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Your playful weather companion")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Features
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(
                    icon: "chart.xyaxis.line",
                    title: "Dynamic Visualizations",
                    description: "Beautiful weather charts and graphs"
                )
                
                FeatureRow(
                    icon: "bell.fill",
                    title: "Smart Notifications",
                    description: "Stay informed about weather changes"
                )
                
                FeatureRow(
                    icon: "gamecontroller.fill",
                    title: "Weather Challenges",
                    description: "Earn points with fun daily challenges"
                )
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Swipe indicator
            Text("Swipe to continue")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .padding(.bottom, 30)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "01A2FF"))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage1_Previews: PreviewProvider {
    static var previews: some View {
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
            
            OnboardingPage1()
        }
    }
}

