//
//  BuildingMarker.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 19/04/26.
//

import SwiftUI

// MARK: - Building Marker

struct BuildingMarker: View {
    let building: CampusBuilding
    let isSelected: Bool
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(building.category.color)
                    .frame(width: isSelected ? 52 : 38, height: isSelected ? 52 : 38)
                    .shadow(color: building.category.color.opacity(0.5),
                            radius: isSelected ? 12 : 4, x: 0, y: 3)
                Image(systemName: building.icon)
                    .font(.system(size: isSelected ? 22 : 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            Triangle()
                .fill(building.category.color)
                .frame(width: 12, height: 7)
                .offset(y: -1)
        }
        .scaleEffect(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.05)) {
                appeared = true
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isSelected)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
