import SwiftUI
import Foundation

/// Represents a single achievement milestone
struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let daysRequired: Int
    let iconName: String
    let unlockNumber: Int
    
    /// Check if this achievement is unlocked based on current streak
    func isUnlocked(daysSinceLastRelapse: Int) -> Bool {
        return daysSinceLastRelapse >= daysRequired
    }
}

/// Manages the achievements system and tracks user progress
final class AchievementStore: ObservableObject {
    @Published var achievements: [Achievement] = []
    @AppStorage("achievementsResetCount") private var resetCount: Int = 0
    
    init() {
        setupAchievements()
    }
    
    private func setupAchievements() {
        achievements = [
            Achievement(
                title: "First Steps",
                description: "Today marks the beginning of something powerful. This decision is a promise to yourself. Small steps create big change.",
                daysRequired: 1,
                iconName: "medal",
                unlockNumber: 1
            ),
            Achievement(
                title: "Momentum Builder",
                description: "The first few days are tough—but you're tougher. You're already proving your strength. Keep your reasons close.",
                daysRequired: 3,
                iconName: "lock",
                unlockNumber: 2
            ),
            Achievement(
                title: "Breakthrough",
                description: "You've pushed through the initial resistance. Momentum is building, and the shift has begun. Keep going.",
                daysRequired: 5,
                iconName: "lock",
                unlockNumber: 3
            ),
            Achievement(
                title: "Mind Shift",
                description: "Your mind is beginning to adapt. New neural pathways are forming. You're becoming the person you want to be.",
                daysRequired: 7,
                iconName: "lock",
                unlockNumber: 4
            ),
            Achievement(
                title: "Foundation",
                description: "Two weeks of commitment shows real dedication. You're building a solid foundation for lasting change.",
                daysRequired: 14,
                iconName: "lock",
                unlockNumber: 5
            ),
            Achievement(
                title: "Transformation",
                description: "A month of progress—your discipline is transforming into habit. The new you is emerging stronger every day.",
                daysRequired: 30,
                iconName: "lock",
                unlockNumber: 6
            )
        ]
    }
    
    /// Get the number of unlocked achievements based on current streak
    func getUnlockedCount(daysSinceLastRelapse: Int) -> Int {
        return achievements.filter { $0.isUnlocked(daysSinceLastRelapse: daysSinceLastRelapse) }.count
    }
    
    /// Reset achievements (for testing or user preference)
    func resetAchievements() {
        resetCount += 1
        objectWillChange.send()
    }
    
    /// Get the next achievement to unlock
    func getNextAchievement(daysSinceLastRelapse: Int) -> Achievement? {
        return achievements.first { !$0.isUnlocked(daysSinceLastRelapse: daysSinceLastRelapse) }
    }
}
