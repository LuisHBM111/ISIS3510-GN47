//
//  MapViewModel.swift
//  CampusNavigationFrontend
//

import SwiftUI
import MapKit
import CoreLocation
import Observation

@Observable
final class MapViewModel: NSObject, CLLocationManagerDelegate {
    var selectedBuilding: CampusBuilding? = nil
    var selectedCategory: BuildingCategory? = nil
    var searchText: String = ""

    // Retained manager — must be a stored property so the delegate callbacks survive
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    var filteredBuildings: [CampusBuilding] {
        CampusMockData.buildings.filter { building in
            let matchesCategory = selectedCategory == nil || building.category == selectedCategory
            let matchesSearch   = searchText.isEmpty || building.name.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Authorization state changes are handled automatically by MapKit
    }
}
