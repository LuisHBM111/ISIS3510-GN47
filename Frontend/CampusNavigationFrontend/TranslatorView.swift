//
//  TranslatorView.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 20/03/26.
//

import SwiftUI
import AVFoundation
import Combine

// MARK: - Models
struct TranslationEntry: Identifiable {
    let id = UUID()
    let original: String
    let translated: String
    let fromLanguage: String
    let toLanguage: String
    let date: Date
}

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

    func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        let tempText = transcription
        transcription = translation
        translation = tempText
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

// MARK: - Main View
struct VoiceTranslatorView: View {
    @StateObject private var viewModel = VoiceTranslatorViewModel()
    @State private var showHistory = false

    var body: some View {
        ZStack {
            Color(hex: "F2F3F5")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ScrollView {
                    VStack(spacing: 16) {
                        languageSelectorCard

                        if !viewModel.transcription.isEmpty {
                            transcriptionCard
                        }

                        if !viewModel.translation.isEmpty {
                            translationCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 280)
                }
            }

            VStack {
                Spacer()
                recordingPanel
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(entries: viewModel.history)
        }
    }

    // MARK: - Top Bar
    var topBar: some View {
        HStack {
            Spacer()

            VStack(spacing: 2) {
                Text("Voice Translator")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
            }

            Spacer()

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(hex: "F2F3F5"))
    }

    // MARK: - Language Selector
    var languageSelectorCard: some View {
        HStack(spacing: 0) {
            Button(action: { viewModel.swapLanguages() }) {
                Text(viewModel.sourceLanguage)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }

            Button(action: { viewModel.swapLanguages() }) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "D4A017"))
                    .padding(.horizontal, 12)
            }

            Button(action: { viewModel.swapLanguages() }) {
                Text(viewModel.targetLanguage)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    // MARK: - Transcription Card
    var transcriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "D4A017"))
                    .frame(width: 8, height: 8)
                Text("TRANSCRIPTION")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .tracking(1.2)
            }
            Text(viewModel.transcription)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(.black)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    // MARK: - Translation Card
    var translationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "character.book.closed")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "D4A017"))
                Text("TRANSLATION")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "D4A017"))
                    .tracking(1.2)
            }
            Text(viewModel.translation)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Spacer()
                Button(action: { viewModel.speakTranslation() }) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6B7280"))
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action: { viewModel.copyTranslation() }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6B7280"))
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    // MARK: - Recording Panel
    var recordingPanel: some View {
        VStack(spacing: 16) {
            if viewModel.isRecording {
                WaveformView(isAnimating: true)
                    .frame(height: 60)
                    .padding(.horizontal, 40)
                    .transition(.opacity.combined(with: .scale))
            }

            Text(viewModel.isRecording ? "Tap to stop recording" : "Tap to start recording")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "9CA3AF"))

            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleRecording()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "F5C518"))
                        .frame(width: 72, height: 72)
                        .shadow(color: Color(hex: "F5C518").opacity(0.5), radius: 12, x: 0, y: 6)
                    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
            }

            Color.clear.frame(height: 20)
        }
        .padding(.top, 16)
        .padding(.bottom, 90)
        .frame(maxWidth: .infinity)
        .background(
            Color(hex: "F2F3F5")
                .overlay(
                    LinearGradient(
                        colors: [Color(hex: "F2F3F5").opacity(0), Color(hex: "F2F3F5")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
}

// MARK: - Waveform
struct WaveformView: View {
    let isAnimating: Bool
    private let barHeights: [CGFloat] = [20, 35, 50, 42, 55, 60, 45, 38, 52, 30, 44, 25]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<12, id: \.self) { i in
                WaveBar(height: barHeights[i], delay: Double(i) * 0.08, isAnimating: isAnimating)
            }
        }
    }
}

struct WaveBar: View {
    let height: CGFloat
    let delay: Double
    let isAnimating: Bool
    @State private var scale: CGFloat = 1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    colors: [Color(hex: "F5C518"), Color(hex: "F5C518").opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 5, height: height * scale)
            .onAppear {
                guard isAnimating else { return }
                withAnimation(
                    .easeInOut(duration: 0.5 + delay * 0.3)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) { scale = 0.3 }
            }
    }
}

// MARK: - History View
struct HistoryView: View {
    let entries: [TranslationEntry]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(entries) { entry in
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.original)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(entry.translated)
                        .font(.system(size: 16, weight: .semibold))
                    Text("\(entry.fromLanguage) → \(entry.toLanguage)")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "D4A017"))
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    VoiceTranslatorView()
}
