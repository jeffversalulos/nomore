import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
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
                    VStack(spacing: 32) {
                        Spacer(minLength: 20)
                        
                        // Recovery Progress Circle - Using extracted component
                        RecoveryProgressCard(currentTime: now)
                            .environmentObject(streakStore)
                        
                        // Quit Date Prediction - Using extracted component
                        QuitDatePredictionCard()
                            .environmentObject(streakStore)
                        
                        // Motivational Message - Using extracted component
                        MotivationalMessageCard()
                        
                        // Progress Chart Section - Using extracted component
                        ProgressChartCard()
                            .environmentObject(dailyUsageStore)
                        
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
    AnalyticsView()
        .environmentObject(StreakStore())
        .environmentObject(DailyUsageStore())
}
