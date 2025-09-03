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
                        
                        // Recovery Progress Circle - REUSE SobrietyRing component
                        recoveryProgressSection
                        
                        // Quit Date Prediction - REUSE QuitDateCard logic
                        quitDatePredictionSection
                        
                        // Motivational Message
                        motivationalMessageSection
                        
                        // Progress Chart Section - REUSE WeeklyProgressTracker logic
                        progressChartSection
                        
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
    
    // MARK: - Recovery Progress Section
    private var recoveryProgressSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // REUSE the actual SobrietyRing component from CounterView
                let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
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
    
    // MARK: - Quit Date Prediction Section
    private var quitDatePredictionSection: some View {
        VStack(spacing: 12) {
            Text("You're on track to quit porn by:")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(formattedQuitDate)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        )
                )
        }
        .padding(.horizontal, 24)
    }
    
    // REUSE the EXACT same logic as QuitDateCard (90 days from start date)
    private var formattedQuitDate: String {
        let quitDate = Calendar.current.date(byAdding: .day, value: 90, to: streakStore.lastRelapseDate) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: quitDate)
    }
    
    // MARK: - Motivational Message Section
    private var motivationalMessageSection: some View {
        Text("You've made it through the hardest part. Your foundation is stronger. Reflect on how far you've come.")
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Theme.textSecondary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 32)
    }
    
    // MARK: - Progress Chart Section
    private var progressChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your progress")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // REUSE WeeklyProgressTracker logic for real progress data
            progressChart
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 24)
    }
    
    // MARK: - Progress Chart
    private var progressChart: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height: CGFloat = 100
            
            ZStack {
                // Background grid lines
                Path { path in
                    for i in 0...4 {
                        let y = CGFloat(i) * (height / 4)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                
                // Progress line using EXACT WeeklyProgressTracker logic
                Path { path in
                    let points = generateProgressPoints(width: width, height: height)
                    guard let firstPoint = points.first else { return }
                    
                    path.move(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [Theme.aqua, Theme.mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                
                // Progress area fill
                Path { path in
                    let points = generateProgressPoints(width: width, height: height)
                    guard let firstPoint = points.first else { return }
                    
                    path.move(to: CGPoint(x: firstPoint.x, y: height))
                    path.addLine(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.addLine(to: CGPoint(x: points.last?.x ?? width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [Theme.aqua.opacity(0.3), Theme.mint.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .frame(height: 100)
    }
    
    // MARK: - Helper Methods
    // REUSE EXACT WeeklyProgressTracker logic for generating progress points
    private func generateProgressPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        let calendar = Calendar.current
        let today = Date()
        var points: [CGPoint] = []
        
        // Use EXACT same sliding window as WeeklyProgressTracker (-5 to +1 days)
        for i in -5...1 {
            guard let date = calendar.date(byAdding: .day, value: i, to: today) else { continue }
            
            // Map the 7 days (-5 to +1) to x positions (0 to width)
            let dayIndex = i + 5 // Convert -5...1 to 0...6
            let x = (CGFloat(dayIndex) / 6.0) * width
            
            // REUSE EXACT WeeklyProgressTracker logic
            let isCompleted = hasAppUsageOnDate(date)
            let isFuture = date > today
            
            // Calculate y position based on completion status
            let progress: Double
            if isFuture {
                progress = 0.3 // Future days show lower
            } else if isCompleted {
                progress = 0.8 // Completed days show higher
            } else {
                progress = 0.1 // Missed days show lower
            }
            
            let y = height - (CGFloat(progress) * height * 0.8) - (height * 0.1)
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
    
    // REUSE EXACT WeeklyProgressTracker logic for app usage checking
    private func hasAppUsageOnDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        // For future dates, always return false
        if date > today {
            return false
        }
        
        // Use the DailyUsageStore to check if the app was used on this date
        return dailyUsageStore.hasUsageOnDate(date)
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(StreakStore())
        .environmentObject(DailyUsageStore())
}
