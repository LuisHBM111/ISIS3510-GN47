import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    var isConnected: Bool = true

    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            Task { @MainActor in
                self?.isConnected = connected
            }
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
}
