import Foundation
enum CampusAPI {
    static let baseURL = "https://interactive-map-uniandes-backend-1008290497746.us-central1.run.app"

    static func route(from origin: String, to destination: String) async throws -> RouteResponse {
        var comps = URLComponents(string: "\(baseURL)/api/v1/routes/graph/path")!
        comps.queryItems = [
            URLQueryItem(name: "from", value: origin),
            URLQueryItem(name: "to", value: destination)
        ]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        return try JSONDecoder().decode(RouteResponse.self, from: data)
    }
}

struct RouteResponse: Decodable {
    let from: String
    let to: String
    let totalTimeMinutes: Double
    let path: [Node]

    struct Node: Decodable, Identifiable, Hashable {
        let id: String
        let label: String
    }

    var labels: [String] { path.map(\.label) }
    var totalMinutes: Int { max(1, Int(totalTimeMinutes.rounded(.up))) }
}
