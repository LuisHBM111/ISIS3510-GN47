//
//  HistoryView.swift
//  CampusNavigationFrontend
//

import SwiftUI

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
