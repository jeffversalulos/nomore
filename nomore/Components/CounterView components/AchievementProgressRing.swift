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
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.black.opacity(0.3), lineWidth: 18)
                .frame(width: 192, height: 192)
            
            // Progress ring with same gradient as SobrietyRing
            Circle()
                .trim(from: 0, to: max(0.001, min(progressData.progress, 1)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Theme.aqua, Theme.accent, Theme.aqua]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progressData.progress)
                .frame(width: 192, height: 192)
            
            // Center achievement icon - clickable
            Button {
                showingAchievementsSheet = true
            } label: {
                LottieView(animation: .named("MainCircle"))
                    .playing(loopMode: .loop)
                    .animationSpeed(0.6)
                    .frame(width: 317, height: 317)
                    .blur(radius: 2)
                    .saturation(1.3)
                    .scaleEffect(isGlowing ? 1.05 : 1.0)
                    .shadow(color: Theme.accent.opacity(isGlowing ? 0.6 : 0.3), radius: isGlowing ? 30 : 10)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
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
