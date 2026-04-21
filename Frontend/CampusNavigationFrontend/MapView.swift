//
//  MapView.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 18/03/26.
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
    case admin    = "Administrativo"

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

// MARK: - Campus Data

let campusBuildings: [CampusBuilding] = [
    CampusBuilding(
        name: "Edificio ML",
        shortName: "ML",
        coordinate: CLLocationCoordinate2D(latitude: 4.6030, longitude: -74.0651),
        category: .academic,
        description: "Facultad de Ingeniería y Ciencias",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Edificio B",
        shortName: "B",
        coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0664),
        category: .academic,
        description: "Facultad de Ciencias Sociales",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Edificio R",
        shortName: "R",
        coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0640),
        category: .academic,
        description: "Aulas generales y posgrados",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Edificio Henry Yerli",
        shortName: "O",
        coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0640),
        category: .academic,
        description: "Aulas generales y posgrados",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Biblioteca General Ramón de Zubiría",
        shortName: "Biblioteca",
        coordinate: CLLocationCoordinate2D(latitude: 4.603145124835193, longitude: -74.06511214436118),
        category: .library,
        description: "Biblioteca central y salas de estudio",
        icon: "books.vertical.fill"
    ),
    CampusBuilding(
        name: "Sede Julio Mario Santo Domingo",
        shortName: "SD",
        coordinate: CLLocationCoordinate2D(latitude: 4.6031, longitude: -74.0649),
        category: .academic,
        description: "Auditorio y centros culturales",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Edificio Arte y Diseño Tx",
        shortName: "TX",
        coordinate: CLLocationCoordinate2D(latitude: 4.601118603281187, longitude: -74.0636527660052),
        category: .academic,
        description: "Aulas , laboratorios y talleres",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Edificio Arquitectura y Diseño",
        shortName: "C",
        coordinate: CLLocationCoordinate2D(latitude: 4.601347079437167, longitude: -74.065219450908),
        category: .academic,
        description: "Aulas y talleres",
        icon: "building.fill"
    ),
    CampusBuilding(
        name: "Centro Deportivo",
        shortName: "La Caneca",
        coordinate: CLLocationCoordinate2D(latitude: 4.600087848729064, longitude: -74.06259413809),
        category: .sports,
        description: "Gimnasio, piscina y canchas",
        icon: "figure.run"
    ),
    CampusBuilding(
        name: "Plaza de Comidas Bloque Z",
        shortName: "Plazoleta Z",
        coordinate: CLLocationCoordinate2D(latitude: 4.602720193216494, longitude: -74.06550224839602),
        category: .food,
        description: "Restaurantes y cafeterías del campus",
        icon: "fork.knife"
    ),
    CampusBuilding(
        name: "Saudade",
        shortName: "Saudade",
        coordinate: CLLocationCoordinate2D(latitude: 4.603372222323348, longitude: -74.06415097196215),
        category: .food,
        description: "Restaurantes y cafeterías del campus",
        icon: "fork.knife"
    ),
    CampusBuilding(
        name: "Ajiaco & Frijoles",
        shortName: "A&F",
        coordinate: CLLocationCoordinate2D(latitude: 4.603650235170581, longitude: -74.06565300928278),
        category: .food,
        description: "Restaurantes y cafeterías del campus",
        icon: "fork.knife"
    ),
    CampusBuilding(
        name: "Starbucks",
        shortName: "Starbucks",
        coordinate: CLLocationCoordinate2D(latitude: 4.602388278858029, longitude: -74.06537405985544),
        category: .food,
        description: "Restaurantes y cafeterías del campus",
        icon: "fork.knife"
    ),
]

// MARK: - Main View


struct CampusMapView: View {
    
    /*
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 4.6020, longitude: -74.0655),
            span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006) //zoom del mapa
        )
    )
     */
     
    @State private var selectedBuilding: CampusBuilding? = nil
    @State private var selectedCategory: BuildingCategory? = nil
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false
    @State private var isSatellite: Bool = false
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var filteredBuildings: [CampusBuilding] {
        campusBuildings.filter { building in
            let matchesCategory = selectedCategory == nil || building.category == selectedCategory
            let matchesSearch   = searchText.isEmpty || building.name.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        ZStack(alignment: .top) {

            // Mapa
            Map(position: $position) {
                ForEach(filteredBuildings) { building in
                    Annotation(building.shortName, coordinate: building.coordinate, anchor: .bottom) {
                        BuildingMarker(building: building, isSelected: selectedBuilding?.id == building.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    selectedBuilding = building
                                }
                            }
                    }
                }
            }
            .mapStyle(isSatellite ? .imagery : .standard)
            .ignoresSafeArea()
            .onAppear{
                CLLocationManager().requestWhenInUseAuthorization()
            }

            //Controles de arriba
            
            
            VStack(spacing: 0) {
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
                if let building = selectedBuilding {
                    BuildingDetailCard(building: building) {
                        withAnimation { selectedBuilding = nil }
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

            // Boton Vista satelite
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
                    .padding(.bottom, selectedBuilding == nil ? 90 : 230)
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedBuilding?.id)
        .animation(.easeInOut(duration: 0.25), value: showSearch)
    }

    // MARK: - Top Bar
    var topBar: some View {
        HStack(spacing: 12) {
            
            Spacer()

            // Buscar
            Button(action: { withAnimation { showSearch.toggle() } }) {
                Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
            }

            /*
            Button(action: {
                withAnimation(.spring()) {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 4.6020, longitude: -74.0655),
                        span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
                    ))
                }
            })
            */
            
        }
    }

    // MARK: - Search Bar
    var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "9CA3AF"))
                .font(.system(size: 14))
            TextField("Buscar edificio...", text: $searchText)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    // MARK: -  Filters
    var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "Todos", icon: "square.grid.2x2.fill",
                           color: Color(hex: "374151"), isSelected: selectedCategory == nil) {
                    withAnimation { selectedCategory = nil }
                }
                ForEach(BuildingCategory.allCases, id: \.self) { cat in
                    FilterChip(label: cat.rawValue, icon: cat.icon,
                               color: cat.color, isSelected: selectedCategory == cat) {
                        withAnimation { selectedCategory = selectedCategory == cat ? nil : cat }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

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

// MARK: - Filter btns

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
    }
}

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
                .padding(.horizontal, 16)
                
                // Action buttons
                
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -4)
        }
    }
    
    
    
    // MARK: - Preview
    #Preview {
        CampusMapView()
    }
}
