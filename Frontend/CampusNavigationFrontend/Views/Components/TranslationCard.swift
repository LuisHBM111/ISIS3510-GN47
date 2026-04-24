//
//  TranslationCard.swift
//  CampusNavigationFrontend
//

import SwiftUI

struct TranslationCard: View {
    let text: String
    let onSpeak: () -> Void
    let onCopy: () -> Void

    var body: some View {
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

            Text(text)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Spacer()
                Button(action: onSpeak) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6B7280"))
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action: onCopy) {
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
}
