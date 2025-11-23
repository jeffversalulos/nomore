import SwiftUI

struct GoalsProgressCard: View {
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var streakStore: StreakStore
    let currentTime: Date
    
    @State private var rotation: Double = 0
    
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
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
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
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
            .background(
                ZStack {
                    // Deep rich background base - using a very dark purple/black
                    Color(red: 0.03, green: 0.02, blue: 0.08)
                    
                    // Dynamic fill gradient that rotates
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Theme.purple.opacity(0.0),
                            Theme.purple.opacity(0.2), // Peak 1
                            Theme.purple.opacity(0.0),
                            Theme.purple.opacity(0.0),
                            Theme.accent.opacity(0.15), // Peak 2
                            Theme.purple.opacity(0.0)
                        ]),
                        center: .center,
                        startAngle: .degrees(rotation),
                        endAngle: .degrees(rotation + 360)
                    )
                    .blur(radius: 20)
                    
                    // Subtle inner glow for depth
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Theme.indigo.opacity(0.3),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 400
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                // Static Border for Definition (Glass Effect)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 8)
            .padding(.horizontal, 24)
            .onAppear {
                withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
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
            HStack(alignment: .center, spacing: 12) {
                // Goal icon
                if let systemImage = goalIcons[goalTitle] {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Theme.purple.opacity(0.5))
                            .frame(width: 32, height: 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Image(systemName: systemImage)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(red: 0.8, green: 0.6, blue: 1.0)) // Light lilac
                    }
                }
                
                // Goal title
                Text(goalTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
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
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: progress >= 1.0 ? 
                                    [Theme.mint, Theme.mint.opacity(0.8)] :
                                    [Theme.accent, Color(red: 0.9, green: 0.6, blue: 0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                        .shadow(color: progress >= 1.0 ? Theme.mint.opacity(0.5) : Theme.accent.opacity(0.5), radius: 8, x: 0, y: 0)
                }
            }
            .frame(height: 8)
            
            // Progress percentage
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
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
