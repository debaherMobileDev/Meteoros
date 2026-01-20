//
//  MeteorosApp.swift
//  Meteoros
//
//  Created by Simon Bakhanets on 20.01.2026.
//

import SwiftUI

@main
struct MeteorosApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView()
            }
        }
    }
}
