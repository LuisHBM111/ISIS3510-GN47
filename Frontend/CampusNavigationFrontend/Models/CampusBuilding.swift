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

    // MARK: - Init from API DTO

    init(from dto: BuildingDTO) {
        self.name        = dto.name
        self.shortName   = dto.shortName
        self.coordinate  = CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude)
        self.category    = BuildingCategory.from(apiString: dto.category)
        self.description = dto.description
        self.icon        = dto.icon
    }

    // Memberwise init (keeps existing mock data working)
    init(name: String, shortName: String, coordinate: CLLocationCoordinate2D,
         category: BuildingCategory, description: String, icon: String) {
        self.name        = name
        self.shortName   = shortName
        self.coordinate  = coordinate
        self.category    = category
        self.description = description
        self.icon        = icon
    }
}

enum BuildingCategory: String, CaseIterable {
    case academic = "Académico"
    case library  = "Biblioteca"
    case sports   = "Deportes"
    case food     = "Comida"
    case admin    = "Administrativo"

    /// Maps the English API string to the Spanish display enum case
    static func from(apiString: String) -> BuildingCategory {
        switch apiString.lowercased() {
        case "academic":  return .academic
        case "library":   return .library
        case "sports":    return .sports
        case "food":      return .food
        case "admin":     return .admin
        default:          return .academic
        }
    }

    var color: Color {
        switch self {
        case .academic: return Color(hex: "F5C518")
        case .library:  return Color(hex: "3B82F6")
        case .sports:   return Color(hex: "10B981")
        case .food:     return Color(hex: "F97316")
        case .admin:    return Color(hex: "8B5CF6")
        }
    }

    var icon: String {
        switch self {
        case .academic: return "building.columns.fill"
        case .library:  return "books.vertical.fill"
        case .sports:   return "figure.run"
        case .food:     return "fork.knife"
        case .admin:    return "person.3.fill"
        }
    }
}
