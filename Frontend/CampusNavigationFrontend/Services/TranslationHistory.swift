import Foundation
import Observation

@MainActor
@Observable
final class TranslationHistory {

    static let shared = TranslationHistory()

    private(set) var entries: [TranslationEntry] = []
    private let key = "translator.history"

    private init() {
        // Synchronous
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([TranslationEntry].self, from: data) {
            entries = Array(saved.prefix(5))
        }
    }

    func add(original: String, translated: String) {
        let entry = TranslationEntry(original: original, translated: translated, date: Date())
        entries.insert(entry, at: 0)
        if entries.count > 5 {
            entries = Array(entries.prefix(5))
        }
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
