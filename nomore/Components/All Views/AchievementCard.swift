import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let daysSinceLastRelapse: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Achievement icon/medal
            ZStack {
                Circle()
                    .fill(isUnlocked ? Theme.mint.opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(isUnlocked ? Theme.mint.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                if isUnlocked {
                    // Check if it's a custom asset or SF Symbol
                    if achievement.iconName.contains(" ") || achievement.iconName.contains(".png") {
                        // Custom image asset
                        Image(achievement.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    } else {
                        // SF Symbol
                        Image(systemName: achievement.iconName)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(Theme.mint)
                    }
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            
            // Achievement content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(achievement.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isUnlocked ? Theme.textPrimary : Theme.textSecondary)
                    
                    Spacer()
                    
                    // Achievement number badge
                    Text("\(achievement.unlockNumber)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isUnlocked ? Theme.mint : .white.opacity(0.4))
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(isUnlocked ? Theme.mint.opacity(0.15) : .white.opacity(0.05))
                        )
                }
                
                // Days requirement
                Text("\(achievement.daysRequired) Days Clean")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isUnlocked ? Theme.mint : .white.opacity(0.5))
                
                // Description
                Text(achievement.description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(isUnlocked ? Theme.textSecondary : .white.opacity(0.4))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(isUnlocked ? Theme.surface.opacity(0.8) : Theme.surface.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isUnlocked ? Theme.mint.opacity(0.2) : Theme.surfaceStroke.opacity(0.3), lineWidth: 1)
                )
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
        .scaleEffect(isUnlocked ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.3), value: isUnlocked)
    }
}

#Preview {
    let unlockedAchievement = Achievement(
        title: "First Steps",
        description: "Today marks the beginning of something powerful. This decision is a promise to yourself. Small steps create big change.",
        daysRequired: 1,
        iconName: "medal",
        unlockNumber: 1
    )
    
    let lockedAchievement = Achievement(
        title: "Momentum Builder",
        description: "The first few days are tough—but you're tougher. You're already proving your strength. Keep your reasons close.",
        daysRequired: 3,
        iconName: "lock",
        unlockNumber: 2
    )
    
    return VStack(spacing: 20) {
        AchievementCard(achievement: unlockedAchievement, isUnlocked: true, daysSinceLastRelapse: 5)
        AchievementCard(achievement: lockedAchievement, isUnlocked: false, daysSinceLastRelapse: 1)
    }
    .padding()
    .appBackground()
}
