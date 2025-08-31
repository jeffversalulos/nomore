//
//  AppearanceConfigurator.swift
//  nomore
//
//  Centralized UI appearance configuration
//

import SwiftUI
import UIKit

/// Handles all app-wide UI appearance configuration
struct AppearanceConfigurator {
    
    /// Configures the global appearance for the entire app
    static func configure() {
        configureTabBar()
        configureNavigationBar()
    }
    
    // MARK: - Private Configuration Methods
    
    private static func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        tabBarAppearance.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Set unselected tab item color to light gray for better readability
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        // Force override any default blue tint
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.lightGray.withAlphaComponent(0.7)
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7)
        ]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private static func configureNavigationBar() {
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
