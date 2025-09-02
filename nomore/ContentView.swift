//
//  ContentView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content with fade transition
            ZStack {
                // Only one view is visible at a time with fade transition
                Group {
                    if selectedTab == 0 {
                        CounterView(selectedTab: $selectedTab)
                            .transition(.opacity)
                    } else if selectedTab == 1 {
                        JournalView()
                            .transition(.opacity)
                    } else if selectedTab == 2 {
                        MeditationView()
                            .transition(.opacity)
                    } else if selectedTab == 3 {
                        GoalsView()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
            
            // Gradient overlay to fade content behind tab bar
            VStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black.opacity(0.4), location: 0.3),
                        .init(color: .black.opacity(0.8), location: 0.7),
                        .init(color: .black.opacity(0.95), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            // Custom floating tab bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
        }
        .appBackground()
    }
}



#Preview {
    let dailyUsageStore = DailyUsageStore()
    let appStreakStore = AppStreakStore(dailyUsageStore: dailyUsageStore)
    
    return ContentView()
        .environmentObject(StreakStore())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
        .environmentObject(OnboardingManager())
        .environmentObject(dailyUsageStore)
        .environmentObject(AchievementStore())
        .environmentObject(appStreakStore)
}
