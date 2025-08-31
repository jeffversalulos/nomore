//
//  AppContainer.swift
//  nomore
//
//  Dependency Injection Container
//  Manages all app-level stores and their dependencies
//

import SwiftUI

/// Central container that manages all app-level dependencies and their initialization
final class AppContainer: ObservableObject {
    
    // MARK: - Stores
    @Published private(set) var streakStore: StreakStore
    @Published private(set) var journalStore: JournalStore
    @Published private(set) var goalsStore: GoalsStore
    @Published private(set) var onboardingManager: OnboardingManager
    @Published private(set) var dailyUsageStore: DailyUsageStore
    @Published private(set) var achievementStore: AchievementStore
    @Published private(set) var appStreakStore: AppStreakStore
    
    // MARK: - Initialization
    init() {
        // Initialize independent stores first
        self.streakStore = StreakStore()
        self.journalStore = JournalStore()
        self.goalsStore = GoalsStore()
        self.onboardingManager = OnboardingManager()
        self.achievementStore = AchievementStore()
        
        // Initialize dependent stores
        let dailyUsage = DailyUsageStore()
        self.dailyUsageStore = dailyUsage
        self.appStreakStore = AppStreakStore(dailyUsageStore: dailyUsage)
        
        // Setup any cross-store dependencies here if needed
        setupDependencies()
    }
    
    // MARK: - Private Methods
    private func setupDependencies() {
        // Configure any relationships between stores here
        // For example, if stores need to communicate with each other
    }
}

// MARK: - Environment Injection Helper
extension View {
    func injectAppContainer(_ container: AppContainer) -> some View {
        self
            .environmentObject(container.streakStore)
            .environmentObject(container.journalStore)
            .environmentObject(container.goalsStore)
            .environmentObject(container.onboardingManager)
            .environmentObject(container.dailyUsageStore)
            .environmentObject(container.achievementStore)
            .environmentObject(container.appStreakStore)
    }
}
