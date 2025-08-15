//
//  ContentView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    init() {
        // Force unselected tabs to be gray instead of default blue
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.7)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CounterView(selectedTab: $selectedTab)
                .tabItem { Label("Counter", systemImage: "timer") }
                .tag(0)

            JournalView()
                .tabItem { Label("Journal", systemImage: "square.and.pencil") }
                .tag(1)

            MeditationView()
                .tabItem { Label("Meditate", systemImage: "brain.head.profile") }
                .tag(2)

            GoalsView()
                .tabItem { Label("Purpose", systemImage: "ellipsis.circle") }
                .tag(3)
        }
        .tint(.white)
        .background(.clear)
        .appBackground()
    }
}

#Preview {
    ContentView()
        .environmentObject(StreakStore())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
}
