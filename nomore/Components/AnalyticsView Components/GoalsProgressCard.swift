import SwiftUI

struct GoalsProgressCard: View {
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var streakStore: StreakStore
    let currentTime: Date
    
    // Goal completion timeframes based on recovery research (in days)
    private let goalTimeframes: [String: Int] = [
        "Stronger relationships": 90,        // 3 months for relationship improvements
        "Improved self-confidence": 60,      // 2 months for confidence building
        "Improved mood and happiness": 45,   // 6-7 weeks for mood stabilization
        "More energy and motivation": 30,    // 1 month for energy improvements
        "Improved desire and sex life": 120, // 4 months for sexual health recovery
        "Improved self-control": 75,         // 2.5 months for self-control development
        "Improved focus and clarity": 21     // 3 weeks for cognitive improvements
    ]
    
    var selectedGoals: [String] {
        goalsStore.selectedGoals
    }
    
    var body: some View {
        if !selectedGoals.isEmpty {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Your Goals")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Goals list with dividers
                VStack(spacing: 0) {
                    ForEach(Array(selectedGoals.enumerated()), id: \.element) { index, goalTitle in
                        GoalProgressRow(
                            goalTitle: goalTitle,
                            progress: calculateProgress(for: goalTitle),
                            timeRemaining: calculateTimeRemaining(for: goalTitle)
                        )
                        
                        // Add divider between goals (but not after the last one)
                        if index < selectedGoals.count - 1 {
                            Rectangle()
                                .fill(Theme.textSecondary.opacity(0.5))
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.surface)
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
            )
            .padding(.horizontal, 24)
            .softShadow()
        }
    }
    
    private func calculateProgress(for goalTitle: String) -> Double {
        let secondsSinceLastRelapse = currentTime.timeIntervalSince(streakStore.lastRelapseDate)
        let daysSinceLastRelapse = secondsSinceLastRelapse / (24 * 3600)
        
        // Get the timeframe for this goal (default to 60 days if not found)
        let goalTimeframe = Double(goalTimeframes[goalTitle] ?? 60)
        
        // Calculate progress (0.0 to 1.0)
        let progress = min(daysSinceLastRelapse / goalTimeframe, 1.0)
        return max(progress, 0.0)
    }
    
    private func calculateTimeRemaining(for goalTitle: String) -> String {
        let secondsSinceLastRelapse = currentTime.timeIntervalSince(streakStore.lastRelapseDate)
        let daysSinceLastRelapse = Int(secondsSinceLastRelapse / (24 * 3600))
        
        let goalTimeframe = goalTimeframes[goalTitle] ?? 60
        let remainingDays = max(goalTimeframe - daysSinceLastRelapse, 0)
        
        if remainingDays == 0 {
            return "Completed!"
        } else if remainingDays == 1 {
            return "1 day left"
        } else if remainingDays < 7 {
            return "\(remainingDays) days left"
        } else if remainingDays < 30 {
            let weeks = remainingDays / 7
            let extraDays = remainingDays % 7
            if extraDays == 0 {
                return "\(weeks)w left"
            } else {
                return "\(weeks)w \(extraDays)d left"
            }
        } else {
            let months = remainingDays / 30
            let extraDays = remainingDays % 30
            if extraDays == 0 {
                return "\(months)mo left"
            } else {
                return "\(months)mo \(extraDays)d left"
            }
        }
    }
}

struct GoalProgressRow: View {
    let goalTitle: String
    let progress: Double
    let timeRemaining: String
    
    // Map goal titles to icons
    private let goalIcons: [String: String] = [
        "Stronger relationships": "heart.fill",
        "Improved self-confidence": "person.fill",
        "Improved mood and happiness": "face.smiling.fill",
        "More energy and motivation": "bolt.fill",
        "Improved desire and sex life": "doc.text.fill",
        "Improved self-control": "brain.head.profile",
        "Improved focus and clarity": "target"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Goal header
            HStack(alignment: .center, spacing: 12) {
                // Goal icon
                if let systemImage = goalIcons[goalTitle] {
                    Image(systemName: systemImage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Theme.accent)
                        .frame(width: 24, height: 24)
                }
                
                // Goal title
                Text(goalTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Achievement badge or time remaining
                if progress >= 1.0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Theme.mint)
                        
                        Text("Achieved")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Theme.mint)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.mint.opacity(0.15))
                    )
                } else {
                    Text(timeRemaining)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Theme.surfaceTwo.opacity(0.3))
                        )
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Theme.surfaceTwo.opacity(0.3))
                        .frame(height: 6)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: progress >= 1.0 ? 
                                    [Theme.mint, Theme.mint.opacity(0.8)] :
                                    [Theme.accent, Theme.aqua],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
            
            // Progress percentage
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

#Preview {
    let goalsStore = GoalsStore()
    let streakStore = StreakStore()
    
    // Add some sample goals for preview
    goalsStore.setGoals([
        "Stronger relationships",
        "Improved self-confidence",
        "More energy and motivation"
    ])
    
    return GoalsProgressCard(currentTime: Date())
        .environmentObject(goalsStore)
        .environmentObject(streakStore)
        .appBackground()
}
