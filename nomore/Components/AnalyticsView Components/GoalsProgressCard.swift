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
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Your Goals")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                // Goals container
                VStack(spacing: 16) {
                    ForEach(selectedGoals, id: \.self) { goalTitle in
                        GoalProgressRow(
                            goalTitle: goalTitle,
                            progress: calculateProgress(for: goalTitle),
                            timeRemaining: calculateTimeRemaining(for: goalTitle)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.surface)
                        .stroke(Theme.surfaceStroke, lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .softShadow()
            }
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
            HStack {
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
                
                // Time remaining
                Text(timeRemaining)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(progress >= 1.0 ? Theme.mint : Theme.textSecondary)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.surfaceTwo.opacity(0.3))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: progress >= 1.0 ? 
                                    [Theme.mint, Theme.mint.opacity(0.8)] :
                                    [Theme.accent, Theme.aqua],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 8)
            
            // Progress percentage
            HStack {
                Text("\(Int(progress * 100))% complete")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                
                Spacer()
                
                if progress >= 1.0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Theme.mint)
                        
                        Text("Achieved")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Theme.mint)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.surfaceTwo.opacity(0.2))
                .stroke(progress >= 1.0 ? Theme.mint.opacity(0.3) : Theme.surfaceStroke.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    let goalsStore = GoalsStore()
    let streakStore = StreakStore()
    
    return GoalsProgressCard(currentTime: Date())
        .environmentObject(goalsStore)
        .environmentObject(streakStore)
        .appBackground()
}
