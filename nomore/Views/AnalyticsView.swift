import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var consistencyStore: ConsistencyStore
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Analytics")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 48) {
                        Spacer(minLength: 20)
                        
                        // Your Progress Section - New glowing cards
                        YourProgressSection()
                            .environmentObject(streakStore)
                        
                        // Recovery Progress Circle - Using extracted component
                        RecoveryProgressCard(currentTime: now)
                            .environmentObject(streakStore)
                        
                        // Goals Progress Section - Using extracted component
                        GoalsProgressCard(currentTime: now)
                            .environmentObject(streakStore)
                            .environmentObject(goalsStore)
                        
                        // Quit Date Prediction - Using extracted component
                        QuitDatePredictionCard()
                            .environmentObject(streakStore)
                        
                        // Motivational Message - Using extracted component
                        MotivationalMessageCard()
                        
                        // Consistency Score - Using extracted component
                        ConsistencyScoreCard()
                            .environmentObject(consistencyStore)
                        
                        // Add some bottom padding for better scrolling experience
                        Spacer(minLength: 50)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .appBackground()
        .onReceive(timer) { value in
            withAnimation(.easeInOut(duration: 0.3)) {
                now = value
            }
        }
    }
}

#Preview {
    let goalsStore = GoalsStore()
    
    // Add some sample goals for preview
    goalsStore.setGoals([
        "Stronger relationships",
        "Improved self-confidence",
        "More energy and motivation",
        "Improved focus and clarity"
    ])
    
    return AnalyticsView()
        .environmentObject(StreakStore())
        .environmentObject(DailyUsageStore())
        .environmentObject(goalsStore)
        .environmentObject(AchievementStore())
        .environmentObject(ConsistencyStore())
}
