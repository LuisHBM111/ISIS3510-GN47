//
//  VoiceTranslatorViewModel.swift
//  CampusNavigationFrontend
//

import Foundation
import AVFoundation
import Observation
#if os(iOS)
import UIKit
#endif

// MARK: - ViewModel
@MainActor
@Observable
final class VoiceTranslatorViewModel {
    var sourceLanguage: String = "Spanish"
    var targetLanguage: String = "English"
    var transcription: String = "¿Dónde se encuentra el edificio de ingeniería y a qué hora comienza la clase de física?"
    var translation: String = "Where is the engineering building located and what time does the physics class start?"
    var isRecording: Bool = true
    var history: [TranslationEntry] = []

    private let synthesizer = AVSpeechSynthesizer()

    // Maps display language names to BCP-47 locale codes for speech synthesis
    private let localeCodes: [String: String] = [
        "Spanish": "es-ES",
        "English": "en-US",
        "French":  "fr-FR",
        "German":  "de-DE",
        "Portuguese": "pt-BR"
    ]

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
        guard !translation.isEmpty else { return }
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: translation)
        let localeCode = localeCodes[targetLanguage] ?? "en-US"
        utterance.voice = AVSpeechSynthesisVoice(language: localeCode)
        synthesizer.speak(utterance)
    }

    func copyTranslation() {
        #if os(iOS)
        UIPasteboard.general.string = translation
        // Haptic confirmation so the user knows the copy succeeded
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}
