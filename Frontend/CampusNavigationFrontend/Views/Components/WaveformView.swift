//
//  WaveformView.swift
//  CampusNavigationFrontend
//

import SwiftUI

// MARK: - Waveform Container
struct WaveformView: View {
    let isAnimating: Bool
    private let barHeights: [CGFloat] = [20, 35, 50, 42, 55, 60, 45, 38, 52, 30, 44, 25]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<12, id: \.self) { i in
                WaveBar(
                    height: barHeights[i],
                    delay: Double(i) * 0.08,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

// MARK: - Individual Bar
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
