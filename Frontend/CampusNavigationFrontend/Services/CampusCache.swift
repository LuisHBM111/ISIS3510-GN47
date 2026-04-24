import Foundation

actor CampusCache {
    static let shared = CampusCache()
    private let defaults = UserDefaults.standard

    func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    static func routeKey(from: String, to: String) -> String {
        "route.\(from.lowercased()).\(to.lowercased())"
    }
    static let routeCountsKey = "route.counts"
}
