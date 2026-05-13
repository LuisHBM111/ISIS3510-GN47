import Foundation

enum CampusAPI {
    static let baseURL = "https://interactive-map-uniandes-backend-1008290497746.us-central1.run.app"
    static let firebaseKey = "AIzaSyC20AP-AH5Aj5Te5qIgKvPYM9jfmMA8gN0"

    static func route(from origin: String, to destination: String) async throws -> RouteResponse {
        var comps = URLComponents(string: "\(baseURL)/api/v1/routes/graph/path")!
        comps.queryItems = [
            URLQueryItem(name: "from", value: origin),
            URLQueryItem(name: "to", value: destination)
        ]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        return try JSONDecoder().decode(RouteResponse.self, from: data)
    }

    static func fetchBuildings() async throws -> [BuildingDTO] {
        let url = URL(string: "\(baseURL)/api/v1/buildings")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([BuildingDTO].self, from: data)
    }

    static func signIn(email: String, password: String) async throws -> FirebaseAuthResponse {
        try await firebaseCall(path: "accounts:signInWithPassword", email: email, password: password)
    }

    static func signUp(email: String, password: String) async throws -> FirebaseAuthResponse {
        try await firebaseCall(path: "accounts:signUp", email: email, password: password)
    }

    private static func firebaseCall(path: String, email: String, password: String) async throws -> FirebaseAuthResponse {
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/\(path)?key=\(firebaseKey)")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(FirebaseAuthRequest(email: email, password: password, returnSecureToken: true))
        let (data, resp) = try await URLSession.shared.data(for: req)
        if let http = resp as? HTTPURLResponse, http.statusCode != 200 {
            let msg = (try? JSONDecoder().decode(FirebaseErrorResponse.self, from: data).error.message) ?? "Error de autenticación"
            throw NSError(domain: "Firebase", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: prettyFirebaseMessage(msg)])
        }
        return try JSONDecoder().decode(FirebaseAuthResponse.self, from: data)
    }

    private static func prettyFirebaseMessage(_ raw: String) -> String {
        switch raw {
        case "EMAIL_NOT_FOUND", "INVALID_PASSWORD", "INVALID_LOGIN_CREDENTIALS":
            return "Correo o contraseña incorrectos."
        case "EMAIL_EXISTS":
            return "Ese correo ya está registrado."
        case "WEAK_PASSWORD : Password should be at least 6 characters":
            return "La contraseña debe tener al menos 6 caracteres."
        case "INVALID_EMAIL":
            return "El correo no es válido."
        default:
            return raw
        }
    }
}

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

struct FirebaseAuthRequest: Codable {
    let email: String
    let password: String
    let returnSecureToken: Bool
}

struct FirebaseAuthResponse: Codable {
    let idToken: String
    let email: String
    let localId: String
}

struct FirebaseErrorResponse: Codable {
    struct Inner: Codable { let message: String }
    let error: Inner
}
