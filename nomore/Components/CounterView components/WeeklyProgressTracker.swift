import SwiftUI

struct WeeklyProgressTracker: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
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
                                .fill(getCircleFillColor(for: weekDay))
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            weekDay.isToday ? Theme.accent.opacity(0.6) : 
                                            getCircleStrokeColor(for: weekDay),
                                            lineWidth: weekDay.isToday ? 2 : 1
                                        )
                                )
                                .softShadow()
                            
                            if weekDay.isFuture {
                                // Future days remain empty
                            } else if weekDay.isCompleted {
                                // Checkmark for days when app was opened
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            } else {
                                // X symbol for days when app was not opened (past days only)
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)
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
        
        // Create a sliding window of 7 days where today is always the 6th position (index 5)
        // This means we show 5 days before today, today, and 1 day after today
        var weekDays: [WeekDay] = []
        
        for i in -5...1 {
            guard let date = calendar.date(byAdding: .day, value: i, to: today) else { continue }
            
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
        
        // Use the DailyUsageStore to check if the app was used on this date
        return dailyUsageStore.hasUsageOnDate(date)
    }
    
    private func getCircleFillColor(for weekDay: WeekDay) -> Color {
        if weekDay.isFuture {
            return Theme.surface
        } else if weekDay.isCompleted {
            return Theme.accent
        } else {
            return Theme.surface
        }
    }
    
    private func getCircleStrokeColor(for weekDay: WeekDay) -> Color {
        if weekDay.isCompleted {
            return Theme.accent
        } else {
            return Theme.surfaceStroke
        }
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
        .environmentObject(DailyUsageStore())
        .padding()
        .appBackground()
}
