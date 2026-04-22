import Foundation
enum CampusAPI {
    static let baseURL = "https://interactive-map-uniandes-backend-1008290497746.us-central1.run.app"
    static let firebaseKey = "AIzaSyC20AP-AH5Aj5Te5qIgKvPYM9jfmMA8gN0"
    static func login(email: String, password: String) async throws {
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(firebaseKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ])
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw CampusAPIError("Correo o contraseña incorrectos.")
        }
    }
    static func route(from origin: String, to destination: String) async throws -> RouteResponse {
        var comps = URLComponents(string: "\(baseURL)/api/v1/routes/graph/path")!
        comps.queryItems = [
            URLQueryItem(name: "from", value: origin),
            URLQueryItem(name: "to", value: destination)
        ]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        return try JSONDecoder().decode(RouteResponse.self, from: data)
    }
    static func uploadSchedule(fileURL: URL) async throws -> [ScheduleClass] {
        let url = URL(string: "\(baseURL)/api/v1/schedule/upload")!
        let fileData = try Data(contentsOf: fileURL)
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\nContent-Type: text/calendar\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)

        struct Event: Decodable {
            let summary: String
            let start: String
            let end: String
            let location: String
        }
        let events = try JSONDecoder().decode([Event].self, from: data)
        return events.map {
            ScheduleClass(day: "Lunes", title: $0.summary, code: "",
                          startTime: $0.start, endTime: $0.end,
                          building: "", room: $0.location)
        }
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

struct CampusAPIError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}
