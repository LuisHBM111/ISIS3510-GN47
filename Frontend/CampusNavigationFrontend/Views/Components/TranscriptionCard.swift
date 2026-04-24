//
//  TranscriptionCard.swift
//  CampusNavigationFrontend
//

import SwiftUI

struct TranscriptionCard: View {
    let text: String

    var body: some View {
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
            Text(text)
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
}
