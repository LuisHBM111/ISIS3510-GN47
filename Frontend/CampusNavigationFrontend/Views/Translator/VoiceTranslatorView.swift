//
//  VoiceTranslatorView.swift
//  CampusNavigationFrontend
//

import SwiftUI

// MARK: - Main View
struct VoiceTranslatorView: View {
    @State private var viewModel = VoiceTranslatorViewModel()
    @State private var showHistory = false

    var body: some View {
        ZStack {
            Color(hex: "F2F3F5")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView()

                ScrollView {
                    VStack(spacing: 16) {
                        LanguageSelectorCard(
                            sourceLanguage: viewModel.sourceLanguage,
                            targetLanguage: viewModel.targetLanguage,
                            onSwap: viewModel.swapLanguages
                        )

                        if !viewModel.transcription.isEmpty {
                            TranscriptionCard(text: viewModel.transcription)
                        }

                        if !viewModel.translation.isEmpty {
                            TranslationCard(
                                text: viewModel.translation,
                                onSpeak: viewModel.speakTranslation,
                                onCopy: viewModel.copyTranslation
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 280)
                }
            }

            VStack {
                Spacer()
                RecordingPanel(
                    isRecording: viewModel.isRecording,
                    onToggle: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.toggleRecording()
                        }
                    }
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(entries: viewModel.history)
        }
    }
}

// MARK: - Preview
#Preview {
    VoiceTranslatorView()
}
