import Foundation
import SwiftUI

struct Purpose: Identifiable, Codable, Equatable {
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

/// Manages user's recovery purposes and motivations
final class PurposeStore: ObservableObject {
    @Published private(set) var purposes: [Purpose] = []
    
    private let defaultsKey = "recoveryPurposesJSON"
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
        if purposes.isEmpty {
            setupDefaultPurposes()
        }
    }
    
    private func load() {
        guard let json = defaults.string(forKey: defaultsKey),
              let data = json.data(using: .utf8) else {
            purposes = []
            return
        }
        purposes = (try? decoder.decode([Purpose].self, from: data)) ?? []
    }
    
    private func persist() {
        guard let data = try? encoder.encode(purposes),
              let json = String(data: data, encoding: .utf8) else { return }
        defaults.set(json, forKey: defaultsKey)
    }
    
    private func setupDefaultPurposes() {
        let defaultPurposes = [
            Purpose(
                title: "Better Health",
                description: "Improve my physical and mental wellbeing",
                systemImage: "heart.fill"
            ),
            Purpose(
                title: "Financial Freedom",
                description: "Save money and build a better future",
                systemImage: "dollarsign.circle.fill"
            ),
            Purpose(
                title: "Family & Relationships",
                description: "Strengthen bonds with loved ones",
                systemImage: "figure.2.and.child.holdinghands"
            ),
            Purpose(
                title: "Career Growth",
                description: "Focus on professional development",
                systemImage: "briefcase.fill"
            ),
            Purpose(
                title: "Mental Clarity",
                description: "Think clearer and make better decisions",
                systemImage: "brain.head.profile"
            ),
            Purpose(
                title: "Self-Respect",
                description: "Rebuild confidence and self-worth",
                systemImage: "person.fill.checkmark"
            ),
            Purpose(
                title: "Better Sleep",
                description: "Improve sleep quality and energy levels",
                systemImage: "bed.double.fill"
            ),
            Purpose(
                title: "Fitness Goals",
                description: "Get back in shape and stay active",
                systemImage: "figure.run"
            )
        ]
        
        purposes = defaultPurposes
        persist()
    }
    
    func togglePurposeSelection(_ purpose: Purpose) {
        if let index = purposes.firstIndex(where: { $0.id == purpose.id }) {
            purposes[index].isSelected.toggle()
            persist()
        }
    }
    
    func addCustomPurpose(title: String, description: String, imageData: Data? = nil) {
        let newPurpose = Purpose(
            title: title,
            description: description,
            customImageData: imageData,
            isSelected: true
        )
        purposes.append(newPurpose)
        persist()
    }
    
    func deletePurpose(_ purpose: Purpose) {
        purposes.removeAll { $0.id == purpose.id }
        persist()
    }
    
    var selectedPurposes: [Purpose] {
        purposes.filter { $0.isSelected }
    }
    
    func clearAllSelections() {
        for index in purposes.indices {
            purposes[index].isSelected = false
        }
        persist()
    }
}
