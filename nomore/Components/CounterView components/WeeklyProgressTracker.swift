import SwiftUI

struct WeeklyProgressTracker: View {
    @EnvironmentObject var streakStore: StreakStore
    @State private var currentWeekDays: [WeekDay] = []
    
    private let timer = Timer.publish(every: 3600, on: .main, in: .common).autoconnect() // Update hourly
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(currentWeekDays, id: \.date) { weekDay in
                    VStack(spacing: 6) {
                        // Day circle indicator
                        ZStack {
                            Circle()
                                .fill(weekDay.isCompleted ? Theme.accent : Theme.surface)
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            weekDay.isToday ? Theme.accent.opacity(0.6) : 
                                            (weekDay.isCompleted ? Theme.accent : Theme.surfaceStroke),
                                            lineWidth: weekDay.isToday ? 2 : 1
                                        )
                                )
                                .softShadow()
                            
                            if weekDay.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            } else if weekDay.isToday {
                                // Today indicator when not completed - subtle pulsing dot
                                Circle()
                                    .fill(Theme.accent.opacity(0.4))
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(weekDay.isToday ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: weekDay.isToday)
                            }
                        }
                        .scaleEffect(weekDay.isToday ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: weekDay.isToday)
                        .opacity(weekDay.isFuture ? 0.4 : 1.0)
                        
                        // Day letter
                        Text(weekDay.dayLetter)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(
                                weekDay.isToday ? Theme.textPrimary : Theme.textSecondary
                            )
                            .opacity(weekDay.isFuture ? 0.4 : 1.0)
                    }
                }
            }
        }
        .onAppear {
            updateWeekDays()
        }
        .onReceive(timer) { _ in
            updateWeekDays()
        }
    }
    
    private func updateWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the start of the current week (Monday)
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var weekDays: [WeekDay] = []
        
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) else { continue }
            
            let dayLetter = getDayLetter(for: date)
            let isToday = calendar.isDate(date, inSameDayAs: today)
            let isCompleted = hasAppUsageOnDate(date)
            let isFuture = date > today
            
            weekDays.append(WeekDay(
                date: date,
                dayLetter: dayLetter,
                isToday: isToday,
                isCompleted: isCompleted,
                isFuture: isFuture
            ))
        }
        
        currentWeekDays = weekDays
    }
    
    private func getDayLetter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE" // Single letter day
        return formatter.string(from: date).uppercased()
    }
    
    private func hasAppUsageOnDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        // For future dates, always return false
        if date > today {
            return false
        }
        
        // For today, check if the app has been used (opened)
        // Since we don't have usage tracking yet, we'll assume if the user
        // has maintained their streak for that day, they've used the app
        if calendar.isDate(date, inSameDayAs: today) {
            // App is being used right now, so today counts as completed
            return true
        }
        
        // For past dates, check if it's within the streak period
        let daysSinceLastRelapse = calendar.dateComponents([.day], from: streakStore.lastRelapseDate, to: date).day ?? 0
        
        // If the date is after the last relapse date, consider it a successful day
        return date >= streakStore.lastRelapseDate && daysSinceLastRelapse >= 0
    }
}

struct WeekDay {
    let date: Date
    let dayLetter: String
    let isToday: Bool
    let isCompleted: Bool
    let isFuture: Bool
}

#Preview {
    WeeklyProgressTracker()
        .environmentObject(StreakStore())
        .padding()
        .appBackground()
}
