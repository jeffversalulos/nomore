import Foundation
import SwiftUI

struct Goal: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var systemImage: String?
    var customImageData: Data?
    var isSelected: Bool
    var dateCreated: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        systemImage: String? = nil,
        customImageData: Data? = nil,
        isSelected: Bool = false,
        dateCreated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.customImageData = customImageData
        self.isSelected = isSelected
        self.dateCreated = dateCreated
    }
}

/// Manages user's recovery goals and motivations
final class GoalsStore: ObservableObject {
    @Published private(set) var goals: [Goal] = []
    
    private let defaultsKey = "recoveryGoalsJSON"
    private let defaults = UserDefaults.standard
    
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    init() {
        load()
        if goals.isEmpty {
            setupDefaultGoals()
        }
    }
    
    private func load() {
        guard let json = defaults.string(forKey: defaultsKey),
              let data = json.data(using: .utf8) else {
            goals = []
            return
        }
        goals = (try? decoder.decode([Goal].self, from: data)) ?? []
    }
    
    private func persist() {
        guard let data = try? encoder.encode(goals),
              let json = String(data: data, encoding: .utf8) else { return }
        defaults.set(json, forKey: defaultsKey)
    }
    
    private func setupDefaultGoals() {
        let defaultGoals = [
            Goal(
                title: "Better Health",
                description: "Improve my physical and mental wellbeing",
                systemImage: "heart.fill"
            ),
            Goal(
                title: "Financial Freedom",
                description: "Save money and build a better future",
                systemImage: "dollarsign.circle.fill"
            ),
            Goal(
                title: "Family & Relationships",
                description: "Strengthen bonds with loved ones",
                systemImage: "figure.2.and.child.holdinghands"
            ),
            Goal(
                title: "Career Growth",
                description: "Focus on professional development",
                systemImage: "briefcase.fill"
            ),
            Goal(
                title: "Mental Clarity",
                description: "Think clearer and make better decisions",
                systemImage: "brain.head.profile"
            ),
            Goal(
                title: "Self-Respect",
                description: "Rebuild confidence and self-worth",
                systemImage: "person.fill.checkmark"
            ),
            Goal(
                title: "Better Sleep",
                description: "Improve sleep quality and energy levels",
                systemImage: "bed.double.fill"
            ),
            Goal(
                title: "Fitness Goals",
                description: "Get back in shape and stay active",
                systemImage: "figure.run"
            )
        ]
        
        goals = defaultGoals
        persist()
    }
    
    func toggleGoalSelection(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isSelected.toggle()
            persist()
        }
    }
    
    func addCustomGoal(title: String, description: String, imageData: Data? = nil) {
        let newGoal = Goal(
            title: title,
            description: description,
            customImageData: imageData,
            isSelected: true
        )
        goals.append(newGoal)
        persist()
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        persist()
    }
    
    var selectedGoals: [Goal] {
        goals.filter { $0.isSelected }
    }
    
    func clearAllSelections() {
        for index in goals.indices {
            goals[index].isSelected = false
        }
        persist()
    }
}
