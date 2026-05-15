//
//  CampusBuilding.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 19/04/26.
//

import SwiftUI
import MapKit

// MARK: - Models

struct CampusBuilding: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    let coordinate: CLLocationCoordinate2D
    let category: BuildingCategory
    let description: String
    let icon: String
}

enum BuildingCategory: String, CaseIterable {
    case academic = "Académico"
    case library  = "Biblioteca"
    case sports   = "Deportes"
    case food     = "Comida"

    var color: Color {
        switch self {
        case .academic: return Color(hex: "F5C518")
        case .library:  return Color(hex: "3B82F6")
        case .sports:   return Color(hex: "10B981")
        case .food:     return Color(hex: "F97316")
        }
    }

    var icon: String {
        switch self {
        case .academic: return "building.columns.fill"
        case .library:  return "books.vertical.fill"
        case .sports:   return "figure.run"
        case .food:     return "fork.knife"
        }
    }
}
