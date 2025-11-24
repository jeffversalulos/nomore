import SwiftUI

struct YourProgressSection: View {
    @EnvironmentObject var streakStore: StreakStore
    @State private var currentTime = Date()
    @State private var hasInitialized = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack {
                Text("Your Progress")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Subtitle
            Text("Track your journey over time")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 24)
                .padding(.top, -16)
            
            // Grid of progress cards
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ProgressStatCard(
                        icon: "calendar",
                        value: currentStreakDays,
                        label: "Current Streak",
                        iconColor: Color(red: 0.4, green: 0.6, blue: 1.0)
                    )
                    
                    ProgressStatCard(
                        icon: "arrow.up.right",
                        value: longestStreak,
                        label: "Longest Streak",
                        iconColor: Color(red: 0.5, green: 0.4, blue: 1.0)
                    )
                }
                
                HStack(spacing: 16) {
                    ProgressStatCard(
                        icon: "chart.bar.fill",
                        value: averageStreak,
                        label: "Average Streak",
                        iconColor: Color(red: 0.4, green: 0.8, blue: 0.6)
                    )
                    
                    ProgressStatCard(
                        icon: "chart.xyaxis.line",
                        value: totalDays,
                        label: "Total Days",
                        iconColor: Color(red: 1.0, green: 0.6, blue: 0.4)
                    )
                }
            }
            .padding(.horizontal, 24)
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            currentTime = Date()
        }
        .onAppear {
            currentTime = Date()
            // Initialize firstStartDate if needed
            if UserDefaults.standard.double(forKey: "firstStartDate") == 0 {
                UserDefaults.standard.set(streakStore.lastRelapseDate.timeIntervalSince1970, forKey: "firstStartDate")
            }
            hasInitialized = true
        }
    }
    
    // MARK: - Computed Properties
    
    private var currentStreakDays: Int {
        let secondsSinceRelapse = currentTime.timeIntervalSince(streakStore.lastRelapseDate)
        return Int(secondsSinceRelapse / (24 * 3600))
    }
    
    private var longestStreak: Int {
        let stored = UserDefaults.standard.integer(forKey: "personalBestStreak")
        let current = currentStreakDays
        
        if current > stored {
            UserDefaults.standard.set(current, forKey: "personalBestStreak")
            return current
        }
        
        return max(stored, current)
    }
    
    private var averageStreak: Int {
        // Calculate average based on total relapses and current streak
        let totalRelapses = UserDefaults.standard.integer(forKey: "totalRelapses")
        
        if totalRelapses == 0 {
            // No relapses yet, average is the current streak
            return currentStreakDays
        }
        
        // Average = total days / number of attempts (relapses + 1 for current attempt)
        return totalDays / (totalRelapses + 1)
    }
    
    private var totalDays: Int {
        // Get the very first start date (when app was first used)
        let firstStartInterval = UserDefaults.standard.double(forKey: "firstStartDate")
        
        guard firstStartInterval > 0 else {
            // Not initialized yet, return current streak
            return currentStreakDays
        }
        
        let firstStartDate = Date(timeIntervalSince1970: firstStartInterval)
        let secondsSinceFirstStart = currentTime.timeIntervalSince(firstStartDate)
        return max(Int(secondsSinceFirstStart / (24 * 3600)), currentStreakDays)
    }
}

// MARK: - Progress Stat Card Component
struct ProgressStatCard: View {
    let icon: String
    let value: Int
    let label: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon at top
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [iconColor.opacity(0.8), iconColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Value
            Text("\(value)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
            
            // Label
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.45, green: 0.35, blue: 0.88).opacity(0.4),
                            Color(red: 0.55, green: 0.25, blue: 0.95).opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(red: 0.5, green: 0.3, blue: 0.95),
                            Color(red: 0.6, green: 0.4, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
        )
        .shadow(
            color: Color(red: 0.5, green: 0.3, blue: 0.95).opacity(0.4),
            radius: 12,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    YourProgressSection()
        .environmentObject(StreakStore())
        .appBackground()
}


