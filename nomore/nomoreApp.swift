//
//  nomoreApp.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

@main
struct nomoreApp: App {
    @StateObject private var appContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            if appContainer.onboardingManager.hasCompletedOnboarding {
                ContentView()
                    .injectAppContainer(appContainer)
                    .onAppear(perform: AppearanceConfigurator.configure)
            } else {
                OnboardingView {
                    // This closure is called when "Begin Your Recovery" button is pressed
                    // Now we actually complete the onboarding process
                    appContainer.onboardingManager.completeOnboarding()
                }
                .environmentObject(appContainer.onboardingManager)
                .environmentObject(appContainer.goalsStore)
                .onAppear(perform: AppearanceConfigurator.configure)
            }
        }
    }
}
