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
            
            // Custom floating tab bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
        }
        .appBackground()
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    // Tab items data
    private let tabs = [
        (title: "Counter", icon: "timer"),
        (title: "Journal", icon: "square.and.pencil"),
        (title: "Meditate", icon: "brain.head.profile"),
        (title: "Purpose", icon: "ellipsis.circle")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 22))
                        
                        Text(tabs[index].title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(selectedTab == index ? .white : .white.opacity(0.5))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            Capsule()
                .fill(Theme.surface)
                .overlay(
                    Capsule()
                        .stroke(Theme.surfaceStroke, lineWidth: 1)
                )
        )
        .frame(width: min(UIScreen.main.bounds.width - 40, 340))
        .softShadow()
    }
}

#Preview {
    ContentView()
        .environmentObject(StreakStore())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
}
