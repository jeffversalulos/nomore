import SwiftUI
import Foundation

/// Stores and manages the user's consistency score based on app usage patterns.
/// Tracks daily app opens, streaks, and relapses to calculate a 0-100 consistency score.
final class ConsistencyStore: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var consistencyScore: Int = 50 // Start at middle score
    
    // MARK: - Private Storage
    @AppStorage("consistencyScore") private var storedScore: Int = 50
    @AppStorage("lastAppOpenDate") private var lastAppOpenDateString: String = ""
    @AppStorage("consecutiveDaysCount") private var consecutiveDaysCount: Int = 0
    @AppStorage("lastScoreUpdateDate") private var lastScoreUpdateDateString: String = ""
    
    // MARK: - Date Formatters
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Initialization
    init() {
        self.consistencyScore = storedScore
        checkDailyConsistency()
    }
    
    // MARK: - Public Methods
    
    /// Call this when the app opens to track daily usage
    func recordAppOpen() {
        let today = dateFormatter.string(from: Date())
        let lastOpenDate = lastAppOpenDateString
        
        if lastOpenDate != today {
            // New day - check if consecutive or missed days
            if isConsecutiveDay(lastDate: lastOpenDate, currentDate: today) {
                handleConsecutiveDay()
            } else if !lastOpenDate.isEmpty {
                // Missed one or more days
                handleMissedDays(from: lastOpenDate, to: today)
            }
            
            lastAppOpenDateString = today
            lastScoreUpdateDateString = today
        }
    }
    
    /// Call this when user relapses to reduce consistency score
    func recordRelapse() {
        let reduction = Int.random(in: 20...44)
        updateScore(by: -reduction)
        
        // Reset consecutive days on relapse
        consecutiveDaysCount = 0
        
        let today = dateFormatter.string(from: Date())
        lastScoreUpdateDateString = today
    }
    
    // MARK: - Private Methods
    
    private func checkDailyConsistency() {
        let today = dateFormatter.string(from: Date())
        let lastUpdate = lastScoreUpdateDateString
        
        // If we haven't updated today and it's not the first run
        if !lastUpdate.isEmpty && lastUpdate != today {
            let daysMissed = daysBetween(from: lastUpdate, to: today) - 1
            if daysMissed > 0 {
                // Apply penalty for missed days
                let totalReduction = daysMissed * Int.random(in: 4...8)
                updateScore(by: -totalReduction)
            }
        }
    }
    
    private func handleConsecutiveDay() {
        consecutiveDaysCount += 1
        let increase = Int.random(in: 5...11)
        updateScore(by: increase)
    }
    
    private func handleMissedDays(from lastDate: String, to currentDate: String) {
        let daysMissed = daysBetween(from: lastDate, to: currentDate) - 1
        
        if daysMissed > 0 {
            // Reset consecutive days count
            consecutiveDaysCount = 0
            
            // Apply penalty for missed days
            let reductionPerDay = Int.random(in: 4...8)
            let totalReduction = daysMissed * reductionPerDay
            updateScore(by: -totalReduction)
        }
    }
    
    private func updateScore(by change: Int) {
        let newScore = consistencyScore + change
        consistencyScore = max(0, min(100, newScore)) // Clamp between 0-100
        storedScore = consistencyScore
        objectWillChange.send()
    }
    
    private func isConsecutiveDay(lastDate: String, currentDate: String) -> Bool {
        guard !lastDate.isEmpty else { return false }
        return daysBetween(from: lastDate, to: currentDate) == 1
    }
    
    private func daysBetween(from startDateString: String, to endDateString: String) -> Int {
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    
    // MARK: - Computed Properties
    
    var consistencyLevel: String {
        switch consistencyScore {
        case 0..<20:
            return "Getting Started"
        case 20..<40:
            return "Building Habits"
        case 40..<60:
            return "Making Progress"
        case 60..<80:
            return "Strong Consistency"
        case 80..<95:
            return "Excellent Discipline"
        default:
            return "Master Level"
        }
    }
    
    var consistencyColor: Color {
        switch consistencyScore {
        case 0..<20:
            return Color.red.opacity(0.8)
        case 20..<40:
            return Color.orange.opacity(0.8)
        case 40..<60:
            return Color.yellow.opacity(0.8)
        case 60..<80:
            return Theme.aqua
        case 80..<95:
            return Theme.mint
        default:
            return Color.white
        }
    }
}
