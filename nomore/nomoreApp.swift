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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(streakStore)
        }
    }
}
