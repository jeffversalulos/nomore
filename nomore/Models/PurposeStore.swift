import Foundation
import SwiftUI

struct Purpose: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var systemImage: String?
    var customImageFileName: String? // Store filename instead of data
    var isSelected: Bool
    var dateCreated: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        systemImage: String? = nil,
        customImageFileName: String? = nil,
        isSelected: Bool = false,
        dateCreated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.customImageFileName = customImageFileName
        self.isSelected = isSelected
        self.dateCreated = dateCreated
    }
    
    // Helper to get the actual image data when needed
    var customImageData: Data? {
        guard let fileName = customImageFileName else { return nil }
        return PurposeStore.loadImageData(fileName: fileName)
    }
}

/// Manages user's recovery purposes and motivations
final class PurposeStore: ObservableObject {
    @Published private(set) var purposes: [Purpose] = []
    
    private let purposesFileName = "purposes.json"
    private let imagesDirectoryName = "purpose_images"
    
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
        createImagesDirectoryIfNeeded()
        load()
        if purposes.isEmpty {
            setupDefaultPurposes()
        }
    }
    
    // MARK: - File Storage Methods
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var purposesFileURL: URL {
        documentsDirectory.appendingPathComponent(purposesFileName)
    }
    
    private var imagesDirectoryURL: URL {
        documentsDirectory.appendingPathComponent(imagesDirectoryName)
    }
    
    private func createImagesDirectoryIfNeeded() {
        try? FileManager.default.createDirectory(
            at: imagesDirectoryURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: purposesFileURL)
            purposes = try decoder.decode([Purpose].self, from: data)
        } catch {
            // File doesn't exist or is corrupted, start fresh
            purposes = []
        }
    }
    
    private func persist() {
        do {
            let data = try encoder.encode(purposes)
            try data.write(to: purposesFileURL)
        } catch {
            print("Failed to save purposes: \(error)")
        }
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
        var imageFileName: String? = nil
        
        // Save image to file if provided
        if let imageData = imageData {
            imageFileName = saveImageData(imageData)
        }
        
        let newPurpose = Purpose(
            title: title,
            description: description,
            customImageFileName: imageFileName,
            isSelected: true
        )
        purposes.append(newPurpose)
        persist()
    }
    
    func deletePurpose(_ purpose: Purpose) {
        // Delete associated image file if it exists
        if let fileName = purpose.customImageFileName {
            deleteImageFile(fileName: fileName)
        }
        
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
    
    // MARK: - Image File Management
    
    private func saveImageData(_ data: Data) -> String? {
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
    
    static func loadImageData(fileName: String) -> Data? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagesDirectoryURL = documentsDirectory.appendingPathComponent("purpose_images")
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        
        return try? Data(contentsOf: fileURL)
    }
    
    private func deleteImageFile(fileName: String) {
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
