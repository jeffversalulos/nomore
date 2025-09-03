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
                        
                        // Recovery Progress Circle
                        recoveryProgressSection
                        
                        // Quit Date Prediction
                        quitDatePredictionSection
                        
                        // Motivational Message
                        motivationalMessageSection
                        
                        // Progress Chart Section
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
                // Use the EXACT same SobrietyRing component from CounterView
                // Decorative progress ring (90-day horizon) - SAME AS COUNTERVIEW
                let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
                let sobrietyProgress = min(max(secondsSince / (90 * 24 * 3600), 0), 1)
                
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                // Progress circle - using SAME calculation as SobrietyRing
                Circle()
                    .trim(from: 0, to: max(0.001, min(sobrietyProgress, 1)))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Theme.aqua, Theme.accent, Theme.aqua]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: sobrietyProgress)
                
                // Center content
                VStack(spacing: 8) {
                    Text("RECOVERY")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .tracking(1.2)
                    
                    Text("\(Int(sobrietyProgress * 100))%")
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
            
            // Use EXACT same brain rewiring calculation from CounterView (100-day goal)
            let secondsSinceRelapse = now.timeIntervalSince(streakStore.lastRelapseDate)
            let daysSinceRelapse = secondsSinceRelapse / (24 * 3600)
            let remainingDays = max(0, 100.0 - daysSinceRelapse) // 100-day goal like BrainRewiringProgressBar
            let projectedDate = Calendar.current.date(byAdding: .day, value: Int(remainingDays), to: now) ?? now
            
            Text(projectedDate, style: .date)
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
            
            // Use REAL progress data based on WeeklyProgressTracker logic
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
                // Background grid lines (optional)
                Path { path in
                    for i in 0...4 {
                        let y = CGFloat(i) * (height / 4)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                
                // Progress line using REAL data from WeeklyProgressTracker logic
                Path { path in
                    let points = generateRealProgressPoints(width: width, height: height)
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
                    let points = generateRealProgressPoints(width: width, height: height)
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
    // Use REAL data from WeeklyProgressTracker logic to generate progress points
    private func generateRealProgressPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        let calendar = Calendar.current
        let today = Date()
        var points: [CGPoint] = []
        
        // Create a sliding window of 7 days (same as WeeklyProgressTracker)
        let daysToShow = 7
        
        for i in 0..<daysToShow {
            let dayOffset = i - (daysToShow - 1) // Start from 6 days ago
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            
            let x = (CGFloat(i) / CGFloat(daysToShow - 1)) * width
            
            // Use EXACT same logic as WeeklyProgressTracker to determine if day was completed
            let isCompleted = hasAppUsageOnDate(date)
            let isFuture = date > today
            
            // Calculate y position based on real completion data
            let progress: Double
            if isFuture {
                progress = 0.3 // Future days show lower on chart
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
    
    // EXACT same logic as WeeklyProgressTracker
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
