import Foundation
import AVFoundation
import Observation
import Translation
#if os(iOS)
import UIKit
#endif

@MainActor
@Observable
final class VoiceTranslatorViewModel {
    var sourceLanguage: String = "Spanish"
    var targetLanguage: String = "English"
    var transcription: String = ""
    var translation: String = ""
    var isRecording: Bool = false
    var history: [TranslationEntry] = []

    // Controla si se muestra el popup de traducción de Apple
    var showTranslationPopup: Bool = false

    let networkMonitor = NetworkMonitor()
    private let historyKey = "translator.history"
    private let synthesizer = AVSpeechSynthesizer()

    let supportedLanguages: [String] = [
        "Spanish", "English", "French", "German", "Portuguese"
    ]

    let localeCodes: [String: String] = [
        "Spanish":    "es",
        "English":    "en",
        "French":     "fr",
        "German":     "de",
        "Portuguese": "pt"
    ]

    private let speechCodes: [String: String] = [
        "Spanish":    "es-ES",
        "English":    "en-US",
        "French":     "fr-FR",
        "German":     "de-DE",
        "Portuguese": "pt-BR"
    ]

    init() {
        Task {
            let cached = await CampusCache.shared.load([TranslationEntry].self, key: historyKey)
            history = cached ?? []
        }
    }

    // MARK: - Intents

    func swapLanguages() {
        swap(&sourceLanguage, &targetLanguage)
        swap(&transcription, &translation)
    }

    /// Abre el popup nativo de Apple para traducir
    func triggerTranslation() {
        guard !transcription.isEmpty else { return }
        showTranslationPopup = true
    }

    /// Llamado cuando el usuario acepta la traducción del popup de Apple
    func didReceiveTranslation(_ result: String) {
        translation = result
        showTranslationPopup = false

        let entry = TranslationEntry(
            original: transcription,
            translated: result,
            fromLanguage: sourceLanguage,
            toLanguage: targetLanguage,
            date: Date()
        )
        history.insert(entry, at: 0)

        Task {
            await CampusCache.shared.save(history, key: historyKey)
        }
    }

    func toggleRecording() {
        isRecording.toggle()
        if !isRecording && !transcription.isEmpty {
            triggerTranslation()
        }
    }

    func speakTranslation() {
        guard !translation.isEmpty else { return }
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: translation)
        utterance.voice = AVSpeechSynthesisVoice(language: speechCodes[targetLanguage] ?? "en-US")
        synthesizer.speak(utterance)
    }

    func copyTranslation() {
        #if os(iOS)
        UIPasteboard.general.string = translation
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}
