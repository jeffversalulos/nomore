import SwiftUI

/// Stores and manages the user's sobriety streak data.
/// Uses AppStorage (UserDefaults) to persist the last relapse timestamp across launches.
final class StreakStore: ObservableObject {
    /// Persisted last relapse timestamp in seconds since 1970.
    /// Defaults to now for a fresh install so the counter starts immediately.
    @AppStorage("lastRelapseTimeInterval") private var lastRelapseTimeInterval: Double = Date().timeIntervalSince1970

    /// The last relapse date derived from the persisted timestamp.
    var lastRelapseDate: Date {
        get { Date(timeIntervalSince1970: lastRelapseTimeInterval) }
        set { lastRelapseTimeInterval = newValue.timeIntervalSince1970 }
    }

    /// Resets the streak starting point to a given date (defaults to now).
    func resetRelapseDate(to date: Date = Date()) {
        lastRelapseDate = date
        objectWillChange.send()
    }
}


