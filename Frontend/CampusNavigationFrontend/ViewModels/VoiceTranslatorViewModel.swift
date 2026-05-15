import Foundation
import AVFoundation
import NaturalLanguage
import Observation
import Translation
#if os(iOS)
import UIKit
#endif

@MainActor
@Observable
final class VoiceTranslatorViewModel {
    var transcription: String = ""
    var translation: String = ""
    var isRecording: Bool = false
    var history: [TranslationEntry] = []
    var showTranslationPopup: Bool = false

    let networkMonitor = NetworkMonitor()
    private let historyKey = "translator.history"
    private let synthesizer = AVSpeechSynthesizer()

    init() {
        Task {
            let cached = await CampusCache.shared.load([TranslationEntry].self, key: historyKey)
            history = cached ?? []
        }
    }

    // MARK: - Intents

    func triggerTranslation() {
        guard !transcription.isEmpty else { return }
        showTranslationPopup = true
    }

    func didReceiveTranslation(_ result: String) {
        translation = result
        showTranslationPopup = false

        let entry = TranslationEntry(
            original: transcription,
            translated: result,
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

        let recognizer = NLLanguageRecognizer()
        recognizer.processString(translation)
        let detectedCode = recognizer.dominantLanguage?.rawValue ?? "en"

        let utterance = AVSpeechUtterance(string: translation)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceCode(for: detectedCode))
        synthesizer.speak(utterance)
    }

    func copyTranslation() {
        #if os(iOS)
        UIPasteboard.general.string = translation
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }

    private func voiceCode(for languageCode: String) -> String {
        switch languageCode {
        case "es": return "es-ES"
        case "en": return "en-US"
        case "fr": return "fr-FR"
        case "de": return "de-DE"
        case "pt": return "pt-BR"
        default:   return "en-US"
        }
    }
}
