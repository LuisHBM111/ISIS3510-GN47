import SwiftUI
import Translation

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
        
                        // Campo de texto editable
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Escribe tu texto a traducir")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TextEditor(text: $viewModel.transcription)
                                .frame(minHeight: 250)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black.opacity(0.05), radius: 4)

                            if !viewModel.transcription.isEmpty && !viewModel.isRecording {
                                Button {
                                    viewModel.triggerTranslation()
                                } label: {
                                    Label("Traducir", systemImage: "translate")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "D4A017"))
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.horizontal, 4)

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

            
        }
        .translationPresentation(
            isPresented: $viewModel.showTranslationPopup,
            text: viewModel.transcription
        ) { translatedText in
            viewModel.didReceiveTranslation(translatedText)
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(entries: viewModel.history)
        }
    }
}

#Preview {
    VoiceTranslatorView()
}
