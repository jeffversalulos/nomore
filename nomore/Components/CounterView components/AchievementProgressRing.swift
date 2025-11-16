//
//  AchievementProgressRing.swift
//  nomore
//
//  Created by Aa on 2025-01-23.
//

import SwiftUI

struct AchievementProgressRing: View {
    let daysSinceLastRelapse: Double // Changed to Double for fractional days
    let achievementStore: AchievementStore
    @Binding var showingAchievementsSheet: Bool
    
    private var progressData: (current: Achievement?, next: Achievement?, progress: Double, daysToGo: Int) {
        let unlockedAchievements = achievementStore.achievements.filter { 
            $0.isUnlocked(daysSinceLastRelapse: Int(daysSinceLastRelapse)) 
        }
        
        let nextAchievement = achievementStore.getNextAchievement(daysSinceLastRelapse: Int(daysSinceLastRelapse))
        let currentAchievement = unlockedAchievements.last
        
        guard let next = nextAchievement else {
            // All achievements unlocked, show completed bar
            return (currentAchievement, nil, 1.0, 0)
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
        
        let daysToGo = max(0, Int(endDays - currentDays))
        
        return (currentAchievement, next, min(max(progress, 0.0), 1.0), daysToGo)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Achievement icon - clickable (outside the card)
            Button {
                showingAchievementsSheet = true
            } label: {
                if let currentAchievement = progressData.current {
                    // Show the most recent achievement icon
                    // Check if it's a custom asset or SF Symbol
                    if currentAchievement.iconName.contains(" ") || currentAchievement.iconName.contains(".png") {
                        // Custom image asset
                        Image(currentAchievement.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } else {
                        // SF Symbol
                        Image(systemName: currentAchievement.iconName)
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                    }
                } else {
                    // Show grayed-out lock if no achievements unlocked yet
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
            
            // "Next Milestone" header (outside the card)
            HStack(spacing: 6) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.mint)
                
                Text("Next Milestone")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
            
            // Card containing progress bar
            VStack(spacing: 16) {
                // Progress bar
                VStack(spacing: 8) {
                    // The bar itself
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background bar
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 12)
                            
                            // Progress bar with gradient
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Theme.aqua, Theme.accent]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progressData.progress, height: 12)
                                .animation(.easeInOut(duration: 0.3), value: progressData.progress)
                        }
                    }
                    .frame(height: 12)
                    
                    // Days to go text
                    if let next = progressData.next {
                        HStack {
                            Spacer()
                            Text("\(progressData.daysToGo) days to go")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Theme.textPrimary)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
            )
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient
        ScrollView {
            VStack(spacing: 40) {
                // Preview with different progress states
                AchievementProgressRing(
                    daysSinceLastRelapse: 0.42, // 10 hours - should show ~42% between start and "First Steps"
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
            .padding(.vertical, 40)
        }
    }
}
