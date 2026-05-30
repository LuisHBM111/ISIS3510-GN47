import Foundation
import Observation

@MainActor
@Observable
final class UsageTracker {

    static let shared = UsageTracker()

    private(set) var counts: [String: Int] = [:]
    private let key = "usage.counts"

    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([String: Int].self, from: data) {
            counts = saved
        }
    }

    func record(section: String) {
        counts[section, default: 0] += 1
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(counts) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
