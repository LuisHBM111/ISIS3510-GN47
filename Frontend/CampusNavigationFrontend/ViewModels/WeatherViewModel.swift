import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    var temperature: String = "--"
    var symbol: String = "cloud.fill"
    var isLoading = false

    private let locationManager = CLLocationManager()

    func start() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        Task { await self.fetch(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude) }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}

    private func fetch(lat: Double, lon: Double) async {
        isLoading = true
        defer { isLoading = false }
        let urlStr = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,weathercode"
        guard let url = URL(string: urlStr),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let response = try? JSONDecoder().decode(OpenMeteoResponse.self, from: data) else { return }
        temperature = "\(Int(response.current.temperature_2m))°C"
        symbol = weatherSymbol(for: response.current.weathercode)
    }

    private func weatherSymbol(for code: Int) -> String {
        switch code {
        case 0:        return "sun.max.fill"
        case 1...3:    return "cloud.sun.fill"
        case 45, 48:   return "cloud.fog.fill"
        case 51...67:  return "cloud.rain.fill"
        case 71...77:  return "snowflake"
        case 80...82:  return "cloud.drizzle.fill"
        case 95...:    return "cloud.bolt.fill"
        default:       return "cloud.fill"
        }
    }
}

private struct OpenMeteoResponse: Decodable {
    struct Current: Decodable {
        let temperature_2m: Double
        let weathercode: Int
    }
    let current: Current
}
