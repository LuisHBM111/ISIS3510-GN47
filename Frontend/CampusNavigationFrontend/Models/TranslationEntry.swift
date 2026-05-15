import Foundation

// MARK: - Model
struct TranslationEntry: Identifiable, Codable {
    let id: UUID
    let original: String
    let translated: String
    let date: Date

    init(original: String, translated: String, date: Date) {
        self.id = UUID()
        self.original = original
        self.translated = translated
        self.date = date
    }
}
