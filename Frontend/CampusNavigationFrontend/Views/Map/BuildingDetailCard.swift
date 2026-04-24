//
//  BuildingDetailCard.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 19/04/26.
//

import SwiftUI

// MARK: -  Detail Card

struct BuildingDetailCard: View {
    let building: CampusBuilding
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Handle
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "D1D5DB"))
                    .frame(width: 36, height: 4)
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(building.category.color.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: building.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(building.category.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(building.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Text(building.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    HStack(spacing: 6) {
                        Image(systemName: building.category.icon)
                            .font(.system(size: 11))
                        Text(building.category.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(building.category.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(building.category.color.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 2)
                }
                
                Spacer()
                
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "9CA3AF"))
                        .frame(width: 30, height: 30)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(Circle())
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        // ✅ Background, clip y shadow sobre el VStack externo
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -4)
    }
}

// MARK: - Preview
#Preview {
    CampusMapView()
}
