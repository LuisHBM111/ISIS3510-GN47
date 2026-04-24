import Foundation
import Observation

@MainActor
@Observable
final class RouteViewModel {
    var origen: String = "ML 5"
    var destino: String = "RGD 2"
    var route: RouteResponse?
    var isLoading = false
    var errorMessage: String?
    var isOffline: Bool = false
    var showOfflineAlert: Bool = false

    private let analytics = RouteAnalyticsViewModel()
    var topRoutes: [RouteQueryCount] { analytics.topRoutes }

    func onAppear() async {
        await analytics.reload()
    }

    func calculateRoute(isConnected: Bool) async {
        let o = origen.trimmingCharacters(in: .whitespacesAndNewlines)
        let d = destino.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !o.isEmpty, !d.isEmpty else {
            errorMessage = "Debes ingresar origen y destino."
            return
        }
        isLoading = true
        errorMessage = nil
        isOffline = false
        defer { isLoading = false }

        let key = CampusCache.routeKey(from: o, to: d)

        if !isConnected {
            if let cached = await CampusCache.shared.load(RouteResponse.self, key: key) {
                route = cached
                isOffline = true
            } else {
                route = nil
                showOfflineAlert = true
            }
            return
        }

        do {
            let fresh = try await CampusAPI.route(from: o, to: d)
            route = fresh
            await CampusCache.shared.save(fresh, key: key)
            await analytics.record(from: o, to: d)
        } catch {
            if let cached = await CampusCache.shared.load(RouteResponse.self, key: key) {
                route = cached
                isOffline = true
            } else {
                route = nil
                showOfflineAlert = true
            }
        }
    }

    func useRoute(_ query: RouteQueryCount) {
        origen = query.from
        destino = query.to
    }
}
