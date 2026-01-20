//
//  OnboardingPage2.swift
//  Meteoros
//
//  Created on 2026.
//

import SwiftUI

struct OnboardingPage2: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Icon
            Image(systemName: "cloud.sun.rain.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color(hex: "01A2FF"))
                .symbolRenderingMode(.hierarchical)
                .padding(.bottom, 20)
            
            // Title
            Text("Ready to Start!")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Search for any city to get accurate weather forecasts and enjoy gamified weather challenges")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Features list
            VStack(spacing: 20) {
                FeatureItem(
                    icon: "magnifyingglass.circle.fill",
                    title: "Search Any City",
                    description: "Find weather for any location worldwide"
                )
                
                FeatureItem(
                    icon: "chart.bar.fill",
                    title: "5-Day Forecast",
                    description: "Plan ahead with detailed predictions"
                )
                
                FeatureItem(
                    icon: "gamecontroller.fill",
                    title: "Earn Points",
                    description: "Complete challenges and track achievements"
                )
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                hasCompletedOnboarding = true
            }) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "01A2FF"))
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(Color(hex: "01A2FF"))
                .frame(width: 50, height: 50)
                .symbolRenderingMode(.hierarchical)
            
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct OnboardingPage2_Previews: PreviewProvider {
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
            
            OnboardingPage2(hasCompletedOnboarding: .constant(false))
        }
    }
}

