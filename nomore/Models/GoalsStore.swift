import Foundation
import SwiftUI

/// Manages goals selected during onboarding (simple tracking goals)
final class GoalsStore: ObservableObject {
    @Published private(set) var selectedGoals: [String] = []
    
    private let defaultsKey = "selectedOnboardingGoals"
    private let defaults = UserDefaults.standard
    
    init() {
        load()
    }
    
    private func load() {
        selectedGoals = defaults.stringArray(forKey: defaultsKey) ?? []
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
