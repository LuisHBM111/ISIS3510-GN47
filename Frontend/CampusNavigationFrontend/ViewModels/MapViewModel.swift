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
    let networkMonitor = NetworkMonitor()
    private let categoryKey = "map.lastCategory"
    
    var selectedBuilding: CampusBuilding? = nil
    //guardar en cache
    var selectedCategory: BuildingCategory? = nil {
        didSet {
            Task {
                await CampusCache.shared.save(selectedCategory?.rawValue ?? "", key: categoryKey)
            }
        }
    }
    var searchText: String = ""

    // Retained manager — must be a stored property so the delegate callbacks survive
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        Task { @MainActor in
            if let raw = await CampusCache.shared.load(String.self, key: categoryKey),
               let category = BuildingCategory(rawValue: raw) {
                selectedCategory = category
            }
        }
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
