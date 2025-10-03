import SwiftUI

struct ConsistencyScoreCard: View {
    @EnvironmentObject var consistencyStore: ConsistencyStore
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Consistency Score")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            
            // Main Score Display
            HStack(spacing: 24) {
                // Circular Progress Ring
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Theme.surfaceStroke, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    // Progress ring
                    Circle()
                        .trim(from: 0, to: CGFloat(consistencyStore.consistencyScore) / 100.0)
                        .stroke(
                            consistencyStore.consistencyColor,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: consistencyStore.consistencyScore)
                    
                    // Score text in center
                    VStack(spacing: 2) {
                        Text("\(consistencyStore.consistencyScore)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("/ 100")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                
                // Score Details
                VStack(alignment: .leading, spacing: 12) {
                    // Status Level
                    VStack(alignment: .leading, spacing: 4) {
                        Text("STATUS")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                            .tracking(1.0)
                        
                        Text(consistencyStore.consistencyLevel)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(consistencyStore.consistencyColor)
                    }
                    
                    // Progress Indicators
                    VStack(alignment: .leading, spacing: 8) {
                        ScoreFactorRow(
                            icon: "calendar.badge.plus",
                            title: "Daily Check-ins",
                            description: "+5-11 points",
                            color: Theme.mint
                        )
                        
                        ScoreFactorRow(
                            icon: "calendar.badge.minus",
                            title: "Missed Days",
                            description: "-4-8 points",
                            color: Color.orange
                        )
                        
                        ScoreFactorRow(
                            icon: "exclamationmark.triangle",
                            title: "Relapses",
                            description: "-20-44 points",
                            color: Color.red
                        )
                    }
                }
                
                Spacer()
            }
            
            // Progress Bar at bottom
            VStack(spacing: 8) {
                HStack {
                    Text("Progress to Next Level")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Text(nextLevelProgress)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.surfaceStroke)
                            .frame(height: 6)
                        
                        // Progress fill
                        RoundedRectangle(cornerRadius: 4)
                            .fill(consistencyStore.consistencyColor)
                            .frame(width: geometry.size.width * nextLevelProgressPercentage, height: 6)
                            .animation(.easeInOut(duration: 0.8), value: consistencyStore.consistencyScore)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.surface)
                .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
        )
        .softShadow()
        .padding(.horizontal, 24)
    }
    
    // MARK: - Computed Properties
    
    private var nextLevelProgress: String {
        let currentScore = consistencyStore.consistencyScore
        let nextThreshold = getNextThreshold(for: currentScore)
        
        if currentScore >= 100 {
            return "MAX LEVEL"
        }
        
        let remaining = nextThreshold - currentScore
        return "\(remaining) points to go"
    }
    
    private var nextLevelProgressPercentage: CGFloat {
        let currentScore = consistencyStore.consistencyScore
        let nextThreshold = getNextThreshold(for: currentScore)
        let previousThreshold = getPreviousThreshold(for: currentScore)
        
        if currentScore >= 100 {
            return 1.0
        }
        
        let progress = CGFloat(currentScore - previousThreshold) / CGFloat(nextThreshold - previousThreshold)
        return max(0, min(1, progress))
    }
    
    private func getNextThreshold(for score: Int) -> Int {
        let thresholds = [20, 40, 60, 80, 95, 100]
        return thresholds.first { $0 > score } ?? 100
    }
    
    private func getPreviousThreshold(for score: Int) -> Int {
        let thresholds = [0, 20, 40, 60, 80, 95]
        return thresholds.last { $0 <= score } ?? 0
    }
}

// MARK: - Supporting Views

struct ScoreFactorRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }
}

#Preview {
    ConsistencyScoreCard()
        .environmentObject(ConsistencyStore())
        .appBackground()
}
