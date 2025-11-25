//
//  AchievementProgressRing.swift
//  nomore
//
//  Created by Aa on 2025-01-23.
//

import SwiftUI
import Lottie

struct AchievementProgressRing: View {
    let daysSinceLastRelapse: Double // Changed to Double for fractional days
    let achievementStore: AchievementStore
    @Binding var showingAchievementsSheet: Bool
    @State private var isGlowing = false
    
    private var progressData: (current: Achievement?, next: Achievement?, progress: Double) {
        let unlockedAchievements = achievementStore.achievements.filter { 
            $0.isUnlocked(daysSinceLastRelapse: Int(daysSinceLastRelapse)) 
        }
        
        let nextAchievement = achievementStore.getNextAchievement(daysSinceLastRelapse: Int(daysSinceLastRelapse))
        let currentAchievement = unlockedAchievements.last
        
        guard let next = nextAchievement else {
            // All achievements unlocked, show completed ring
            return (currentAchievement, nil, 1.0)
        }
        
        let startDays = Double(currentAchievement?.daysRequired ?? 0)
        let endDays = Double(next.daysRequired)
        let currentDays = daysSinceLastRelapse
        
        // Calculate progress between current and next achievement
        let progress: Double
        if currentDays <= startDays {
            progress = 0.0
        } else if currentDays >= endDays {
            progress = 1.0
        } else {
            let daysBetween = endDays - startDays
            let daysProgressed = currentDays - startDays
            progress = daysProgressed / daysBetween
        }
        
        return (currentAchievement, next, min(max(progress, 0.0), 1.0))
    }
    
    @ViewBuilder
    private var currentAchievementVisual: some View {
        // Display the visual for the current unlocked achievement, or default if none
        switch progressData.current?.title {
        case "First Steps":
            MainCircleVisual_FirstSteps()
        case "Momentum Builder":
            MainCircleVisual_MomentumBuilder()
        case "Breakthrough":
            MainCircleVisual_Breakthrough()
        case "Mind Shift":
            MainCircleVisual_MindShift()
        case "Foundation":
            MainCircleVisual_Foundation()
        case "Transformation":
            MainCircleVisual_Transformation()
        case "Resilient Spirit":
            MainCircleVisual_ResilientSpirit()
        case "Golden Milestone":
            MainCircleVisual_GoldenMilestone()
        case "Mindful Mastery":
            MainCircleVisual_MindfulMastery()
        case "Unstoppable Force":
            MainCircleVisual_UnstoppableForce()
        case "Phoenix Rising":
            MainCircleVisual_PhoenixRising()
        case "Summit Conqueror":
            MainCircleVisual_SummitConqueror()
        default:
            // Default visual for when no achievement is unlocked yet
            MainCircleVisual()
        }
    }
    
    var body: some View {
        ZStack {
            // 1. Refined Background Track
            // Outer soft glow for the track itself to separate from background
            Circle()
                .stroke(Color.black.opacity(0.1), lineWidth: 24)
                .blur(radius: 2)
                .frame(width: 192, height: 192)
            
            // The physical track groove
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.black.opacity(0.3), Color.black.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 20
                )
                .frame(width: 192, height: 192)

            // 2. Neon Glow Layer (Behind the main progress)
            Circle()
                .trim(from: 0, to: max(0.001, min(progressData.progress, 1)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Theme.aqua, Theme.mint, Theme.accent, Theme.aqua]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 22, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .blur(radius: 12)
                .opacity(0.6)
                .frame(width: 192, height: 192)
            
            // 3. Main Premium Progress Ring
            Circle()
                .trim(from: 0, to: max(0.001, min(progressData.progress, 1)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Theme.aqua, Theme.mint, Theme.accent, Theme.aqua]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressData.progress)
                .frame(width: 192, height: 192)
            
            // 4. Glowing Tip Indicator
            // Only show if progress > 0
            if progressData.progress > 0 {
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .shadow(color: Theme.aqua, radius: 4, x: 0, y: 0)
                    .shadow(color: .white, radius: 2, x: 0, y: 0)
                    .offset(y: -96) // Radius of the ring
                    .rotationEffect(.degrees(progressData.progress * 360))
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressData.progress)
            }
            
            // Center achievement icon - clickable
            Button {
                showingAchievementsSheet = true
            } label: {
                currentAchievementVisual
                    .scaleEffect(isGlowing ? 1.02 : 1.0)
                    .shadow(color: Theme.accent.opacity(isGlowing ? 0.5 : 0.2), radius: isGlowing ? 25 : 10)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient
        VStack(spacing: 40) {
            // Preview with different progress states
            AchievementProgressRing(
                daysSinceLastRelapse: 0.42, // 10 hours - should show ~42% between "First Breath" and "First Steps"
                achievementStore: AchievementStore(),
                showingAchievementsSheet: .constant(false)
            )
            
            AchievementProgressRing(
                daysSinceLastRelapse: 25.0, // Between day 14 and day 30 achievements
                achievementStore: AchievementStore(),
                showingAchievementsSheet: .constant(false)
            )
            
            AchievementProgressRing(
                daysSinceLastRelapse: 45.0, // Between day 30 and day 50 achievements
                achievementStore: AchievementStore(),
                showingAchievementsSheet: .constant(false)
            )
        }
    }
}
