import SwiftUI

struct ConsistencyScoreCard: View {
    @EnvironmentObject var consistencyStore: ConsistencyStore
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with Status
            HStack {
                Text("Consistency Score")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text(consistencyStore.consistencyLevel)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(consistencyStore.consistencyColor)
            }
            
            // Main Content - Centered Layout
            VStack(spacing: 16) {
                // Circular Progress Ring - Centered and Larger
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Theme.surfaceStroke, lineWidth: 8)
                        .frame(width: 140, height: 140)
                    
                    // Progress ring
                    Circle()
                        .trim(from: 0, to: CGFloat(consistencyStore.consistencyScore) / 100.0)
                        .stroke(
                            consistencyStore.consistencyColor,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: consistencyStore.consistencyScore)
                    
                    // Score text in center
                    VStack(spacing: 2) {
                        Text("\(consistencyStore.consistencyScore)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("/ 100")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                
                // Progress to Next Level
                VStack(spacing: 8) {
                    HStack {
                        Text("Next Level")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text(nextLevelProgress)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Theme.surfaceStroke)
                                .frame(height: 4)
                            
                            // Progress fill
                            RoundedRectangle(cornerRadius: 3)
                                .fill(consistencyStore.consistencyColor)
                                .frame(width: geometry.size.width * nextLevelProgressPercentage, height: 4)
                                .animation(.easeInOut(duration: 0.8), value: consistencyStore.consistencyScore)
                        }
                    }
                    .frame(height: 4)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
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


#Preview {
    ConsistencyScoreCard()
        .environmentObject(ConsistencyStore())
        .appBackground()
}
