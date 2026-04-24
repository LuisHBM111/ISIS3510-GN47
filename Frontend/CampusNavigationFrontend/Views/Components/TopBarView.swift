//
//  TopBarView.swift
//  CampusNavigationFrontend
//

import SwiftUI

struct TopBarView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Voice Translator")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(hex: "F2F3F5"))
    }
}
