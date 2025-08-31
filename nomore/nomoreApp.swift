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
                    // This closure is called when onboarding is completed
                    appContainer.onboardingManager.hasCompletedOnboarding = true
                }
                .environmentObject(appContainer.onboardingManager)
                .onAppear(perform: AppearanceConfigurator.configure)
            }
        }
    }
}
