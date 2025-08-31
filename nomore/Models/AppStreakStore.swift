import SwiftUI
import Foundation

/// Manages the user's consecutive daily app opening streak.
/// This is separate from the sobriety streak and only tracks consecutive days of app usage.
final class AppStreakStore: ObservableObject {
    @Published private var currentStreak: Int = 0
    private let dailyUsageStore: DailyUsageStore
    
    init(dailyUsageStore: DailyUsageStore) {
        self.dailyUsageStore = dailyUsageStore
        calculateCurrentStreak()
        
        // Listen for changes in daily usage to update streak
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dailyUsageChanged),
            name: NSNotification.Name("DailyUsageChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Gets the current consecutive daily app opening streak
    var consecutiveDaysStreak: Int {
        return currentStreak
    }
    
    /// Calculates the current streak by counting consecutive days backwards from today
    private func calculateCurrentStreak() {
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        
        // Start from today and count backwards
        var currentDate = today
        
        while dailyUsageStore.hasUsageOnDate(currentDate) {
            streak += 1
            
            // Move to previous day
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDate
        }
        
        currentStreak = streak
        objectWillChange.send()
    }
    
    /// Called when daily usage data changes
    @objc private func dailyUsageChanged() {
        calculateCurrentStreak()
    }
    
    /// Forces a recalculation of the current streak (useful for manual updates)
    func refreshStreak() {
        calculateCurrentStreak()
    }
}
