//
//  nomoreApp.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

@main
struct nomoreApp: App {
    @StateObject private var streakStore = StreakStore()
    @StateObject private var journalStore = JournalStore()
    @StateObject private var goalsStore = GoalsStore()
    @StateObject private var onboardingManager = OnboardingManager()
    @StateObject private var dailyUsageStore = DailyUsageStore()
    @StateObject private var achievementStore = AchievementStore()
    
    var body: some Scene {
        WindowGroup {
            if onboardingManager.hasCompletedOnboarding {
                ContentView()
                    .environmentObject(streakStore)
                    .environmentObject(journalStore)
                    .environmentObject(goalsStore)
                    .environmentObject(onboardingManager)
                    .environmentObject(dailyUsageStore)
                    .environmentObject(achievementStore)
                    .onAppear(perform: configureAppearance)
            } else {
                OnboardingView {
                    // This closure is called when onboarding is completed
                    onboardingManager.hasCompletedOnboarding = true
                }
                .environmentObject(onboardingManager)
                .onAppear(perform: configureAppearance)
            }
        }
    }
}

// MARK: - Appearance
extension nomoreApp {
    private func configureAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        tabBarAppearance.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Set unselected tab item color to light gray for better readability
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        // Force override any default blue tint
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.lightGray.withAlphaComponent(0.7)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7)]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .white
    }
}
