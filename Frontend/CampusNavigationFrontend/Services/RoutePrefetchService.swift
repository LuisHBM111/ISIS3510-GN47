

import Foundation

enum RoutePrefetchService {

    static let prefetchLimit = 5

    static func prefetchTopRoutes() async {
                let counts = await CampusCache.shared.load(
            [String: Int].self,
            key: CampusCache.routeCountsKey
        ) ?? [:]

        guard !counts.isEmpty else { return }

        let topPairs: [(from: String, to: String)] = counts
            .sorted { $0.value > $1.value }
            .prefix(prefetchLimit)
            .compactMap { entry in
                let parts = entry.key.split(separator: "|", maxSplits: 1).map(String.init)
                guard parts.count == 2 else { return nil }
                return (from: parts[0], to: parts[1])
            }

        guard !topPairs.isEmpty else { return }

     
        await withTaskGroup(of: Void.self) { group in
            for pair in topPairs {
                group.addTask {
                    guard let fresh = try? await CampusAPI.route(from: pair.from, to: pair.to) else {
                        return
                    }
                    let key = CampusCache.routeKey(from: pair.from, to: pair.to)
                    await CampusCache.shared.save(fresh, key: key)
                }
            }
            
        }
    }
}
