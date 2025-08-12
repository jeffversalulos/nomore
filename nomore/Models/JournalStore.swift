import Foundation
import SwiftUI

struct JournalEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var text: String

    init(id: UUID = UUID(), date: Date = Date(), text: String) {
        self.id = id
        self.date = date
        self.text = text
    }
}

/// Stores user's journal entries locally using UserDefaults via AppStorage.
/// Keeps the API simple and focused for the Journal UI.
final class JournalStore: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = []

    private let defaultsKey = "journalEntriesJSON"
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
    }

    private func load() {
        guard let json = defaults.string(forKey: defaultsKey), let data = json.data(using: .utf8) else {
            entries = []
            return
        }
        entries = (try? decoder.decode([JournalEntry].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? encoder.encode(entries), let json = String(data: data, encoding: .utf8) else { return }
        defaults.set(json, forKey: defaultsKey)
    }

    func addEntry(text: String, date: Date = Date()) {
        entries.insert(JournalEntry(date: date, text: text), at: 0)
        persist()
    }

    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        persist()
    }
}


