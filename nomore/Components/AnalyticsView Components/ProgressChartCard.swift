import SwiftUI

struct ProgressChartCard: View {
    @EnvironmentObject var streakStore: StreakStore
    @State private var currentTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Simple header
            HStack {
                Text("Your Progress")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text(progressMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(progressColor)
            }
            .padding(.horizontal, 24)
            
            // Simple visual: Current streak vs Personal best
            HStack(spacing: 20) {
                // Current streak
                VStack(spacing: 8) {
                    Text("Current")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text("\(currentStreakDays)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Theme.accent)
                    
                    Text("days")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                
                // VS indicator
                Text("vs")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
                
                // Personal best
                VStack(spacing: 8) {
                    Text("Best")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text("\(personalBest)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(isNewRecord ? Theme.mint : Theme.textSecondary)
                    
                    Text("days")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                )
        )
        .padding(.horizontal, 24)
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            currentTime = Date()
        }
        .onAppear {
            currentTime = Date()
        }
    }
    
    // MARK: - Data Properties
    private var currentStreakDays: Int {
        let secondsSinceRelapse = currentTime.timeIntervalSince(streakStore.lastRelapseDate)
        return Int(secondsSinceRelapse / (24 * 3600))
    }
    
    private var personalBest: Int {
        // For now, we'll use a simple heuristic: if current streak > stored best, update it
        // In a real app, you'd want to track this properly in UserDefaults
        let stored = UserDefaults.standard.integer(forKey: "personalBestStreak")
        let current = currentStreakDays
        
        if current > stored {
            UserDefaults.standard.set(current, forKey: "personalBestStreak")
            return current
        }
        
        return max(stored, current)
    }
    
    private var isNewRecord: Bool {
        return currentStreakDays >= personalBest && currentStreakDays > 0
    }
    
    private var progressMessage: String {
        if isNewRecord {
            return "New Record! 🎉"
        } else if currentStreakDays == 0 {
            return "Fresh Start"
        } else {
            let remaining = personalBest - currentStreakDays
            return "\(remaining) to beat record"
        }
    }
    
    private var progressColor: Color {
        if isNewRecord {
            return Theme.mint
        } else if currentStreakDays == 0 {
            return Theme.accent
        } else {
            return Theme.textSecondary
        }
    }
}

#Preview {
    ProgressChartCard()
        .environmentObject(StreakStore())
        .appBackground()
}
