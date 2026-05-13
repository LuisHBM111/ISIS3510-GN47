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

    // MARK: - Buildings state
    var buildings: [CampusBuilding] = []
    var isLoadingBuildings: Bool = false
    var buildingsError: String? = nil

    var selectedBuilding: CampusBuilding? = nil
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
        Task { await fetchBuildings() }
    }

    // MARK: - Fetch buildings from API

    @MainActor
    func fetchBuildings() async {
        isLoadingBuildings = true
        buildingsError = nil
        do {
            let dtos = try await CampusAPI.fetchBuildings()
            buildings = dtos.map { CampusBuilding(from: $0) }
        } catch {
            buildingsError = "No se pudieron cargar los edificios."
            // Fall back to mock data so the map is never empty
            if buildings.isEmpty {
                buildings = CampusMockData.buildings
            }
        }
        isLoadingBuildings = false
    }

    // MARK: - Filtered list used by the map

    var filteredBuildings: [CampusBuilding] {
        buildings.filter { building in
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
