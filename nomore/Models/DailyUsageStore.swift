import SwiftUI

/// Stores and manages daily app usage data.
/// Tracks which days the user has opened the app to provide accurate progress tracking.
final class DailyUsageStore: ObservableObject {
    /// Set of dates (as strings in YYYY-MM-DD format) when the user used the app
    @AppStorage("dailyUsageDates") private var dailyUsageDatesData: Data = Data()
    
    /// Internal set of usage dates for quick lookup
    private var usageDates: Set<String> = []
    
    init() {
        loadUsageDates()
        // Record today's usage when the store is initialized (app opened)
        recordUsageForToday()
    }
    
    /// Records that the app was used today
    func recordUsageForToday() {
        let today = dateString(from: Date())
        if !usageDates.contains(today) {
            usageDates.insert(today)
            saveUsageDates()
            objectWillChange.send()
        }
    }
    
    /// Checks if the app was used on a specific date
    func hasUsageOnDate(_ date: Date) -> Bool {
        let dateStr = dateString(from: date)
        return usageDates.contains(dateStr)
    }
    
    /// Gets all usage dates within a date range
    func getUsageDatesInRange(from startDate: Date, to endDate: Date) -> Set<Date> {
        let calendar = Calendar.current
        var dates: Set<Date> = []
        
        var currentDate = startDate
        while currentDate <= endDate {
            if hasUsageOnDate(currentDate) {
                dates.insert(currentDate)
            }
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    /// Clears all usage data (useful for testing or reset)
    func clearAllUsageData() {
        usageDates.removeAll()
        saveUsageDates()
        objectWillChange.send()
    }
    
    /// Manually record usage for a specific date (useful for testing or backfilling)
    func recordUsage(for date: Date) {
        let dateStr = dateString(from: date)
        if !usageDates.contains(dateStr) {
            usageDates.insert(dateStr)
            saveUsageDates()
            objectWillChange.send()
        }
    }
    
    // MARK: - Private Methods
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    private func loadUsageDates() {
        do {
            let decoded = try JSONDecoder().decode(Set<String>.self, from: dailyUsageDatesData)
            usageDates = decoded
        } catch {
            // If decoding fails, start with empty set
            usageDates = []
        }
    }
    
    private func saveUsageDates() {
        do {
            let encoded = try JSONEncoder().encode(usageDates)
            dailyUsageDatesData = encoded
        } catch {
            // Handle encoding error silently
            print("Failed to save usage dates: \(error)")
        }
    }
}
