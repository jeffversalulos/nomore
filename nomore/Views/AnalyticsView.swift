import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var streakStore: StreakStore
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Constants for calculations
    private let totalRecoveryDays = 365.0 // 1 year for full recovery
    private let quitTargetDays = 365.0 // Target to quit completely in 1 year
    
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
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: recoveryProgress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Theme.aqua, Theme.mint]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: recoveryProgress)
                
                // Center content
                VStack(spacing: 8) {
                    Text("RECOVERY")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .tracking(1.2)
                    
                    Text("\(Int(recoveryProgress * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    
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
            
            Text(projectedQuitDate, style: .date)
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
            
            // Simple progress visualization
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
                
                // Progress line
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
    
    // MARK: - Computed Properties
    private var daysSinceRelapse: Int {
        let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
        return max(0, Int(secondsSince / (24 * 3600)))
    }
    
    private var recoveryProgress: Double {
        let daysSince = Double(daysSinceRelapse)
        return min(max(daysSince / totalRecoveryDays, 0), 1)
    }
    
    private var projectedQuitDate: Date {
        let daysSince = Double(daysSinceRelapse)
        let remainingDays = max(0, quitTargetDays - daysSince)
        return Calendar.current.date(byAdding: .day, value: Int(remainingDays), to: now) ?? now
    }
    
    // MARK: - Helper Methods
    private func generateProgressPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        let daysSince = daysSinceRelapse
        let maxDays = max(daysSince, 7) // Show at least 7 days
        var points: [CGPoint] = []
        
        for i in 0...maxDays {
            let x = (CGFloat(i) / CGFloat(maxDays)) * width
            // Create a gradual upward trend with some variation
            let baseProgress = Double(i) / Double(maxDays)
            let variation = sin(Double(i) * 0.3) * 0.1 // Small variation
            let progress = min(max(baseProgress + variation, 0), 1)
            let y = height - (CGFloat(progress) * height * 0.8) - (height * 0.1) // Leave some margin
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(StreakStore())
}
