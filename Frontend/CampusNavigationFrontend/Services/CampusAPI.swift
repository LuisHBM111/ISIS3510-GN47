import Foundation
enum CampusAPI {
    static let baseURL = "http://127.0.0.1:8000"

    // MARK: - Routes

    static func route(from origin: String, to destination: String) async throws -> RouteResponse {
        var comps = URLComponents(string: "\(baseURL)/api/v1/routes/graph/path")!
        comps.queryItems = [
            URLQueryItem(name: "from", value: origin),
            URLQueryItem(name: "to", value: destination)
        ]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        return try JSONDecoder().decode(RouteResponse.self, from: data)
    }

    // MARK: - Buildings

    static func fetchBuildings() async throws -> [BuildingDTO] {
        let url = URL(string: "\(baseURL)/api/v1/buildings")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([BuildingDTO].self, from: data)
    }
}

// MARK: - Building DTO (matches the backend JSON response)

struct BuildingDTO: Codable {
    let id: String
    let name: String
    let shortName: String
    let latitude: Double
    let longitude: Double
    let category: String
    let description: String
    let icon: String
}

struct RouteResponse: Codable {
    let from: String
    let to: String
    let totalTimeMinutes: Double
    let path: [Node]

    struct Node: Codable, Identifiable, Hashable {
        let id: String
        let label: String
    }

    var labels: [String] { path.map(\.label) }
    var totalMinutes: Int { max(1, Int(totalTimeMinutes.rounded(.up))) }
}
