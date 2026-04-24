//
//  LanguageSelectorCard.swift
//  CampusNavigationFrontend
//

import SwiftUI

struct LanguageSelectorCard: View {
    let sourceLanguage: String
    let targetLanguage: String
    let onSwap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onSwap) {
                Text(sourceLanguage)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }

            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "D4A017"))
                    .padding(.horizontal, 12)
            }

            Button(action: onSwap) {
                Text(targetLanguage)
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
}
