import Foundation
import SwiftUI

// Old Goal structure for migration purposes only
private struct OldGoal: Codable {
    let title: String
    let isSelected: Bool
}

/// Manages goals selected during onboarding (simple tracking goals)
final class GoalsStore: ObservableObject {
    @Published private(set) var selectedGoals: [String] = []
    
    private let defaultsKey = "selectedOnboardingGoals"
    private let defaults = UserDefaults.standard
    
    init() {
        load()
    }
    
    private func load() {
        // First try to load from new key
        selectedGoals = defaults.stringArray(forKey: defaultsKey) ?? []
        
        // If empty, try to migrate from old GoalsStore format
        if selectedGoals.isEmpty {
            migrateFromOldGoalsStore()
        }
        
    }
    
    private func migrateFromOldGoalsStore() {
        let oldKey = "recoveryGoalsJSON"
        guard let json = defaults.string(forKey: oldKey),
              let data = json.data(using: .utf8) else { return }
        
        // Try to decode old Goal objects
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let oldGoals = try decoder.decode([OldGoal].self, from: data)
            let selectedTitles = oldGoals.filter { $0.isSelected }.map { $0.title }
            
            if !selectedTitles.isEmpty {
                selectedGoals = selectedTitles
                persist()
                
                // Clean up old data
                defaults.removeObject(forKey: oldKey)
            }
        } catch {
            // Migration failed, that's okay
        }
    }
    
    private func persist() {
        defaults.set(selectedGoals, forKey: defaultsKey)
    }
    
    func addGoal(_ goalTitle: String) {
        if !selectedGoals.contains(goalTitle) {
            selectedGoals.append(goalTitle)
            persist()
        }
    }
    
    func removeGoal(_ goalTitle: String) {
        selectedGoals.removeAll { $0 == goalTitle }
        persist()
    }
    
    func isGoalSelected(_ goalTitle: String) -> Bool {
        selectedGoals.contains(goalTitle)
    }
    
    func toggleGoalSelection(_ goalTitle: String) {
        if isGoalSelected(goalTitle) {
            removeGoal(goalTitle)
        } else {
            addGoal(goalTitle)
        }
    }
    
    func clearAllSelections() {
        selectedGoals.removeAll()
        persist()
    }
    
    func setGoals(_ goals: [String]) {
        selectedGoals = goals
        persist()
    }
}
