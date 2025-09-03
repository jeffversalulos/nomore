import SwiftUI

struct RecoveryProgressCard: View {
    @EnvironmentObject var streakStore: StreakStore
    let currentTime: Date
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // REUSE the actual SobrietyRing component from CounterView
                let secondsSince = currentTime.timeIntervalSince(streakStore.lastRelapseDate)
                let progress = min(max(secondsSince / (90 * 24 * 3600), 0), 1)
                
                SobrietyRing(progress: progress)
                    .scaleEffect(0.9) // Slightly smaller for analytics view
                
                // Center content overlay
                VStack(spacing: 8) {
                    Text("RECOVERY")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .tracking(1.2)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    
                    // Use EXACT same calculation as CounterView for days
                    let daysSinceRelapse = Int(secondsSince / (24 * 3600))
                    Text("\(daysSinceRelapse) D STREAK")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                        .tracking(0.8)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    RecoveryProgressCard(currentTime: Date())
        .environmentObject(StreakStore())
        .appBackground()
}
