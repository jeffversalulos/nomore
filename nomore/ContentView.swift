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
        TabView(selection: $selectedTab) {
            CounterView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Counter", systemImage: "timer")
                }
                .tag(0)

            MeditationView()
                .tabItem {
                    Label("Meditate", systemImage: "brain.head.profile")
                }
                .tag(1)

            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StreakStore())
}
