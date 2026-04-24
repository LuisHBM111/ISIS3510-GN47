//
//  TranslationEntry.swift
//  CampusNavigationFrontend
//

import Foundation

// MARK: - Model
struct TranslationEntry: Identifiable, Codable {
    let id: UUID
    let original: String
    let translated: String
    let fromLanguage: String
    let toLanguage: String
    let date: Date

    init(original: String, translated: String, fromLanguage: String, toLanguage: String, date: Date) {
        self.id = UUID()
        self.original = original
        self.translated = translated
        self.fromLanguage = fromLanguage
        self.toLanguage = toLanguage
        self.date = date
    }
}
