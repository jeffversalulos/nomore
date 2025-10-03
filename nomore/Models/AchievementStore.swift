import SwiftUI
import Foundation

/// Represents a single achievement milestone
struct Achievement: Identifiable, Codable, Equatable {
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
    
    /// Equatable conformance based on unlockNumber (which is unique)
    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        return lhs.unlockNumber == rhs.unlockNumber
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
                iconName: "arrow.up.circle.fill",
                unlockNumber: 2
            ),
            Achievement(
                title: "Breakthrough",
                description: "You've pushed through the initial resistance. Momentum is building, and the shift has begun. Keep going.",
                daysRequired: 5,
                iconName: "bolt.circle.fill",
                unlockNumber: 3
            ),
            Achievement(
                title: "Mind Shift",
                description: "Your mind is beginning to adapt. New neural pathways are forming. You're becoming the person you want to be.",
                daysRequired: 7,
                iconName: "brain.head.profile",
                unlockNumber: 4
            ),
            Achievement(
                title: "Foundation",
                description: "Two weeks of commitment shows real dedication. You're building a solid foundation for lasting change.",
                daysRequired: 14,
                iconName: "building.columns.fill",
                unlockNumber: 5
            ),
            Achievement(
                title: "Transformation",
                description: "A month of progress—your discipline is transforming into habit. The new you is emerging stronger every day.",
                daysRequired: 30,
                iconName: "sparkles",
                unlockNumber: 6
            ),
            Achievement(
                title: "Resilient Spirit",
                description: "Forty days of unwavering commitment. You've weathered storms and emerged stronger. Your resilience is becoming unbreakable.",
                daysRequired: 40,
                iconName: "shield.fill",
                unlockNumber: 7
            ),
            Achievement(
                title: "Golden Milestone",
                description: "Fifty days of pure dedication—you've reached a golden milestone. Your willpower has been forged into something extraordinary.",
                daysRequired: 50,
                iconName: "star.circle.fill",
                unlockNumber: 8
            ),
            Achievement(
                title: "Mindful Mastery",
                description: "Two months of conscious choice and mindful living. You've mastered the art of saying no and meaning it. True freedom is yours.",
                daysRequired: 60,
                iconName: "figure.mind.and.body",
                unlockNumber: 9
            ),
            Achievement(
                title: "Unstoppable Force",
                description: "Seventy days of relentless progress. You've become an unstoppable force of positive change. Nothing can break your momentum now.",
                daysRequired: 70,
                iconName: "tornado",
                unlockNumber: 10
            ),
            Achievement(
                title: "Phoenix Rising",
                description: "Eighty days of rebirth and renewal. Like a phoenix, you've risen from the ashes stronger, wiser, and more determined than ever.",
                daysRequired: 80,
                iconName: "flame.fill",
                unlockNumber: 11
            ),
            Achievement(
                title: "Summit Conqueror",
                description: "Ninety days at the peak of your power. You've conquered the summit of self-discipline. The view from here is breathtaking.",
                daysRequired: 90,
                iconName: "mountain.2.fill",
                unlockNumber: 12
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
