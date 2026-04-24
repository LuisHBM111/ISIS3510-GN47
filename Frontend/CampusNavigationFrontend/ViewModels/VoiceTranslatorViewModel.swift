//
//  VoiceTranslatorViewModel.swift
//  CampusNavigationFrontend
//

import Foundation
import AVFoundation

// MARK: - ViewModel
@MainActor
final class VoiceTranslatorViewModel: ObservableObject {
    @Published var sourceLanguage: String = "Spanish"
    @Published var targetLanguage: String = "English"
    @Published var transcription: String = "¿Dónde se encuentra el edificio de ingeniería y a qué hora comienza la clase de física?"
    @Published var translation: String = "Where is the engineering building located and what time does the physics class start?"
    @Published var isRecording: Bool = true
    @Published var history: [TranslationEntry] = []

    private let synthesizer = AVSpeechSynthesizer()

    // MARK: - Intents

    func swapLanguages() {
        swap(&sourceLanguage, &targetLanguage)
        swap(&transcription, &translation)
    }

    func toggleRecording() {
        isRecording.toggle()
        if !isRecording && !transcription.isEmpty {
            let entry = TranslationEntry(
                original: transcription,
                translated: translation,
                fromLanguage: sourceLanguage,
                toLanguage: targetLanguage,
                date: Date()
            )
            history.insert(entry, at: 0)
        }
    }

    func speakTranslation() {
        let utterance = AVSpeechUtterance(string: translation)
        utterance.voice = AVSpeechSynthesisVoice(
            language: targetLanguage == "Spanish" ? "es-ES" : "en-US"
        )
        synthesizer.speak(utterance)
    }

    func copyTranslation() {
        #if os(iOS)
        UIPasteboard.general.string = translation
        #endif
    }
}
