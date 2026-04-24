//
//  TranslationEntry.swift
//  CampusNavigationFrontend
//

import Foundation

// MARK: - Model
struct TranslationEntry: Identifiable {
    let id = UUID()
    let original: String
    let translated: String
    let fromLanguage: String
    let toLanguage: String
    let date: Date
}
