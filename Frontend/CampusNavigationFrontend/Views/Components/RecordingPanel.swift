//
//  RecordingPanel.swift
//  CampusNavigationFrontend
//

import SwiftUI

struct RecordingPanel: View {
    let isRecording: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if isRecording {
                WaveformView(isAnimating: true)
                    .frame(height: 60)
                    .padding(.horizontal, 40)
                    .transition(.opacity.combined(with: .scale))
            }

            Text(isRecording ? "Tap to stop recording" : "Tap to start recording")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "9CA3AF"))

            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "F5C518"))
                        .frame(width: 72, height: 72)
                        .shadow(color: Color(hex: "F5C518").opacity(0.5), radius: 12, x: 0, y: 6)
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
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
