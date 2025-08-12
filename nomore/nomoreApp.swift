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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(streakStore)
                .environmentObject(journalStore)
                .onAppear(perform: configureAppearance)
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
