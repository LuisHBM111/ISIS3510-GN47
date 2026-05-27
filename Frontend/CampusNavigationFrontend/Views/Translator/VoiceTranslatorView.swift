import SwiftUI
import Translation

struct VoiceTranslatorView: View {
    @State private var viewModel = VoiceTranslatorViewModel()

    var body: some View {
        ZStack {
            Color(hex: "F2F3F5")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView()

                if !viewModel.networkMonitor.isConnected {
                    HStack {
                        Image(systemName: "wifi.slash")
                        Text("Sin conexión — la traducción no estará disponible")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.85))
                }

                ScrollView {
                    VStack(spacing: 16) {

                        // MARK: Text input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Escribe tu texto a traducir")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TextEditor(text: $viewModel.transcription)
                                .frame(minHeight: 160)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black.opacity(0.05), radius: 4)

                            if !viewModel.transcription.isEmpty {
                                VStack(spacing: 6) {
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

                                    Text("Toca 'Reemplazar' en el popup para guardar la traducción en el historial")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .padding(.horizontal, 4)

                        // MARK: Last translation result
                        if !viewModel.translation.isEmpty {
                            TranslationCard(
                                text: viewModel.translation,
                                onSpeak: viewModel.speakTranslation,
                                onCopy: viewModel.copyTranslation
                            )
                        }

                        // MARK: History (reads singleton — persists across navigation)
                        let entries = TranslationHistory.shared.entries
                        if !entries.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Historial")
                                    .font(.headline)
                                    .foregroundStyle(CampusTheme.ink)

                                ForEach(entries) { entry in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.original)
                                            .font(.subheadline)
                                            .foregroundStyle(CampusTheme.muted)
                                        Text(entry.translated)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(CampusTheme.ink)
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .black.opacity(0.04), radius: 3)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .translationPresentation(
            isPresented: $viewModel.showTranslationPopup,
            text: viewModel.transcription
        ) { translatedText in
            viewModel.didReceiveTranslation(translatedText)
        }
    }
}

#Preview {
    VoiceTranslatorView()
}
