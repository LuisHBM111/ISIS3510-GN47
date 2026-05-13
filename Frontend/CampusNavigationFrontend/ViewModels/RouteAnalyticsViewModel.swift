import Foundation
import Observation

struct RouteQueryCount: Identifiable, Hashable {
    let id = UUID()
    let from: String
    let to: String
    let count: Int
    var label: String { "\(from) → \(to)" }
}

@MainActor
@Observable
final class RouteAnalyticsViewModel {
    var topRoutes: [RouteQueryCount] = []

    func reload() async {
        let counts = await CampusCache.shared.load([String: Int].self, key: CampusCache.routeCountsKey) ?? [:]
        topRoutes = counts
            .sorted { $0.value > $1.value }
            .prefix(5)
            .compactMap { entry in
                let parts = entry.key.split(separator: "|", maxSplits: 1).map(String.init)
                guard parts.count == 2 else { return nil }
                return RouteQueryCount(from: parts[0], to: parts[1], count: entry.value)
            }
    }

    func record(from: String, to: String) async {
        let key = "\(from)|\(to)"
        var counts = await CampusCache.shared.load([String: Int].self, key: CampusCache.routeCountsKey) ?? [:]
        counts[key, default: 0] += 1
        await CampusCache.shared.save(counts, key: CampusCache.routeCountsKey)
        await reload()
    }
}
