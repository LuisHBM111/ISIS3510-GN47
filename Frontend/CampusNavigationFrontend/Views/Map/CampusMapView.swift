//
//  CampusMapView.swift
//  CampusNavigationFrontend
//

import SwiftUI
import MapKit

// MARK: - Main View

struct CampusMapView: View {

    @State private var vm = MapViewModel()
    @State private var showSearch: Bool = false
    @State private var isSatellite: Bool = false
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        ZStack(alignment: .top) {

            // Mapa
            Map(position: $position) {
                ForEach(vm.filteredBuildings) { building in
                    Annotation(building.shortName, coordinate: building.coordinate, anchor: .bottom) {
                        BuildingMarker(building: building, isSelected: vm.selectedBuilding?.id == building.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    vm.selectedBuilding = building
                                }
                            }
                    }
                }
            }
            .mapStyle(isSatellite ? .imagery : .standard)
            .ignoresSafeArea()
            // Location authorization is now handled in MapViewModel.init()

            // Controles de arriba
            VStack(spacing: 0) {
                if !vm.networkMonitor.isConnected {
                    Text("Sin conexión — mostrando datos locales")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.85))
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                if showSearch {
                    searchBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                categoryFilter
                    .padding(.top, 10)

                Spacer()
            }

            // Toca edificio para ver detalles
            VStack {
                Spacer()
                if let building = vm.selectedBuilding {
                    BuildingDetailCard(building: building) {
                        withAnimation { vm.selectedBuilding = nil }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "9CA3AF"))
                        Text("Toca un edificio para ver detalles")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 30)
                }
            }

            // Botón Vista satélite
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { isSatellite.toggle() }) {
                        Image(systemName: isSatellite ? "map.fill" : "globe.americas.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, vm.selectedBuilding == nil ? 90 : 230)
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: vm.selectedBuilding?.id)
        .animation(.easeInOut(duration: 0.25), value: showSearch)
    }

    // MARK: - Top Bar
    var topBar: some View {
        HStack(spacing: 12) {
            Spacer()
            Button(action: { withAnimation { showSearch.toggle() } }) {
                Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
            }
        }
    }

    // MARK: - Search Bar
    var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "9CA3AF"))
                .font(.system(size: 14))
            TextField("Buscar edificio...", text: $vm.searchText)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    // MARK: - Filters
    var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "Todos", icon: "square.grid.2x2.fill",
                           color: Color(hex: "374151"), isSelected: vm.selectedCategory == nil) {
                    withAnimation { vm.selectedCategory = nil }
                }
                ForEach(BuildingCategory.allCases, id: \.self) { cat in
                    FilterChip(label: cat.rawValue, icon: cat.icon,
                               color: cat.color, isSelected: vm.selectedCategory == cat) {
                        withAnimation { vm.selectedCategory = vm.selectedCategory == cat ? nil : cat }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Filter Chips

struct FilterChip: View {
    let label: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color(hex: "374151"))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color.white)
            .clipShape(Capsule())
            .shadow(color: isSelected ? color.opacity(0.4) : Color.black.opacity(0.06),
                    radius: isSelected ? 6 : 3, x: 0, y: 2)
        }
        .accessibilityLabel("\(label) filter\(isSelected ? ", selected" : "")")
    }
}
