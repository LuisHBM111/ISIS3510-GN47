import Foundation
import AVFoundation
import NaturalLanguage
import Observation
import OSLog
#if os(iOS)
import UIKit
#endif

@MainActor
@Observable
final class VoiceTranslatorViewModel {
    var transcription: String = ""
    var translation: String = ""
    var showTranslationPopup: Bool = false

    let networkMonitor = NetworkMonitor()
    private let synthesizer = AVSpeechSynthesizer()
    private var translationStartTime: Date?
    private let timingLogger = Logger(subsystem: "com.campusnavigation", category: "timing")

    // MARK: - Intents

    func triggerTranslation() {
        translationStartTime = Date()
        showTranslationPopup = true
    }

    /// Called by translationPresentation when the user taps "Reemplazar por la traducción"
    func didReceiveTranslation(_ result: String) {
        if let start = translationStartTime {
            translationStartTime = nil
            Task { await TimingAnalyticsViewModel.shared.record(action: "translation", start: start) }
        }
        translation = result
        showTranslationPopup = false
        TranslationHistory.shared.add(original: transcription, translated: result)
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
