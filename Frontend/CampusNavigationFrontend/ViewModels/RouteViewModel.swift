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

    func calculateRoute() async {
        let o = origen.trimmingCharacters(in: .whitespacesAndNewlines)
        let d = destino.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !o.isEmpty, !d.isEmpty else {
            errorMessage = "Debes ingresar origen y destino."
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            route = try await CampusAPI.route(from: o, to: d)
        } catch {
            route = nil
            errorMessage = error.localizedDescription
        }
    }
}
